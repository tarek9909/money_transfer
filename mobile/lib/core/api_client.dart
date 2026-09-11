import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class ApiException implements Exception {
  ApiException(this.message, this.code);
  final String message;
  final String code;

  factory ApiException.fromResponse(Map body) {
    final message = (body['message'] ?? 'Network request failed').toString();
    final code = (body['code'] ?? 'NETWORK_ERROR').toString();
    return switch (code) {
      'UNAUTHORIZED' ||
      'INVALID_REFRESH_TOKEN' => UnauthorizedException(message, code),
      'INSUFFICIENT_BALANCE' => InsufficientBalanceException(message, code),
      'ACCOUNT_WALLET_MISMATCH' => AccountWalletMismatchException(
        message,
        code,
      ),
      'CROSS_CURRENCY_TRANSFER' => CrossCurrencyTransferException(
        message,
        code,
      ),
      'VALIDATION_ERROR' ||
      'INVALID_AMOUNT' => ValidationException(message, code),
      _ => ApiException(message, code),
    };
  }

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, super.code);
}

class InsufficientBalanceException extends ApiException {
  InsufficientBalanceException(super.message, super.code);
}

class AccountWalletMismatchException extends ApiException {
  AccountWalletMismatchException(super.message, super.code);
}

class CrossCurrencyTransferException extends ApiException {
  CrossCurrencyTransferException(super.message, super.code);
}

class ValidationException extends ApiException {
  ValidationException(super.message, super.code);
}

String _moneyForApi(
  Object? value, {
  required String field,
  bool positive = false,
}) {
  final parsed = Decimal.tryParse(value?.toString() ?? '');
  if (parsed == null || (positive && parsed <= Decimal.zero)) {
    throw ValidationException(
      positive
          ? '$field must be greater than zero'
          : '$field must be a valid decimal amount',
      'INVALID_AMOUNT',
    );
  }
  return parsed.toStringAsFixed(2);
}

class TokenStore {
  TokenStore(this.storage);
  final FlutterSecureStorage storage;
  static const accessKey = 'access_token';
  static const refreshKey = 'refresh_token';

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  Future<String?> get accessToken async {
    if (_cachedAccessToken != null && _cachedAccessToken!.isNotEmpty) {
      return _cachedAccessToken;
    }
    try {
      final val = await storage.read(key: accessKey);
      if (val != null && val.isNotEmpty) {
        _cachedAccessToken = val;
        return val;
      }
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      final val = prefs.getString(accessKey);
      if (val != null && val.isNotEmpty) {
        _cachedAccessToken = val;
        return val;
      }
    } catch (_) {}
    return null;
  }

  Future<String?> get refreshToken async {
    if (_cachedRefreshToken != null && _cachedRefreshToken!.isNotEmpty) {
      return _cachedRefreshToken;
    }
    try {
      final val = await storage.read(key: refreshKey);
      if (val != null && val.isNotEmpty) {
        _cachedRefreshToken = val;
        return val;
      }
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      final val = prefs.getString(refreshKey);
      if (val != null && val.isNotEmpty) {
        _cachedRefreshToken = val;
        return val;
      }
    } catch (_) {}
    return null;
  }

  Future<void> save(Map<String, dynamic> session) async {
    final access = session['accessToken']?.toString();
    final refresh = session['refreshToken']?.toString();
    if (access == null ||
        refresh == null ||
        access.isEmpty ||
        refresh.isEmpty) {
      throw ApiException(
        'The server returned an invalid session',
        'INVALID_SESSION',
      );
    }
    _cachedAccessToken = access;
    _cachedRefreshToken = refresh;
    try {
      await storage.write(key: accessKey, value: access);
      await storage.write(key: refreshKey, value: refresh);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(accessKey, access);
      await prefs.setString(refreshKey, refresh);
    } catch (_) {}
  }

  Future<void> saveSession(Session session) => save(session.toJson());

  Future<void> clear() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    try {
      await storage.delete(key: accessKey);
      await storage.delete(key: refreshKey);
    } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(accessKey);
      await prefs.remove(refreshKey);
    } catch (_) {}
  }
}

class ApiClient {
  static const String defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.10.127:4050/api/v1',
  );

  static const List<String> fallbackUrls = [
    'http://192.168.10.127:4050/api/v1',
    'http://127.0.0.1:4050/api/v1',
    'http://10.0.2.2:4050/api/v1',
    'http://localhost:4050/api/v1',
  ];

  ApiClient(this.tokens, {this.onSessionExpired, String? baseUrl}) {
    final effectiveBaseUrl = baseUrl ?? defaultBaseUrl;
    if (const bool.fromEnvironment('dart.vm.product') &&
        !effectiveBaseUrl.startsWith('https://')) {
      throw StateError('Release builds require an HTTPS API_BASE_URL');
    }
    dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'content-type': 'application/json'},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final body = response.data;
          if (body is Map && body['success'] == true) {
            response.data = body['data'];
          }
          handler.next(response);
        },
        onError: (error, handler) {
          final body = error.response?.data;
          if (body is Map && body['success'] == false) {
            handler.next(
              error.copyWith(error: ApiException.fromResponse(body)),
            );
            return;
          }
          handler.next(error);
        },
      ),
    );
    Future.microtask(initBaseUrl);
  }

  final TokenStore tokens;
  final void Function()? onSessionExpired;
  late final Dio dio;
  Future<void>? _refreshOperation;

  String get currentBaseUrl => dio.options.baseUrl;

  void updateBaseUrl(String newUrl) {
    dio.options.baseUrl = newUrl;
  }

  Future<void> saveBaseUrl(String url) async {
    updateBaseUrl(url);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_base_url', url);
    } catch (_) {}
  }

  Future<void> initBaseUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('api_base_url');
      if (saved != null && saved.trim().isNotEmpty) {
        dio.options.baseUrl = saved.trim();
        return;
      }
    } catch (_) {}
  }

  Future<bool> testConnection([String? url]) async {
    try {
      final base = (url ?? dio.options.baseUrl).trim();
      final healthUrl = base.endsWith('/api/v1')
          ? base.replaceAll(RegExp(r'/api/v1$'), '/health')
          : (base.endsWith('/') ? '${base}health' : '$base/health');
      final probeDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      final res = await probeDio.get(healthUrl);
      return res.statusCode == 200 &&
          res.data is Map &&
          res.data['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> autoDiscoverWorkingUrl() async {
    if (await testConnection(dio.options.baseUrl)) {
      return dio.options.baseUrl;
    }
    for (final candidate in fallbackUrls) {
      if (candidate == dio.options.baseUrl) continue;
      if (await testConnection(candidate)) {
        await saveBaseUrl(candidate);
        return candidate;
      }
    }
    return null;
  }

  Future<void> _refreshWithLock() async {
    final existing = _refreshOperation;
    if (existing != null) return existing;
    final operation = refresh().then((_) {});
    _refreshOperation = operation;
    try {
      await operation;
    } finally {
      if (identical(_refreshOperation, operation)) _refreshOperation = null;
    }
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool authenticated = true,
    bool retry = true,
  }) async {
    try {
      final token = authenticated ? await tokens.accessToken : null;
      if (authenticated && (token == null || token.isEmpty)) {
        throw UnauthorizedException(
          'Authentication is required',
          'UNAUTHORIZED',
        );
      }
      final response = await dio.request<dynamic>(
        path,
        options: Options(
          method: method,
          headers: token == null ? null : {'authorization': 'Bearer $token'},
        ),
        data: data,
        queryParameters: query,
      );
      return response.data;
    } on DioException catch (error) {
      if (retry &&
          (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout)) {
        final newUrl = await autoDiscoverWorkingUrl();
        if (newUrl != null) {
          return _request(
            method,
            path,
            data: data,
            query: query,
            authenticated: authenticated,
            retry: false,
          );
        }
      }
      if (authenticated && retry && error.response?.statusCode == 401) {
        final refreshToken = await tokens.refreshToken;
        if (refreshToken != null) {
          try {
            await _refreshWithLock();
            return _request(
              method,
              path,
              data: data,
              query: query,
              authenticated: authenticated,
              retry: false,
            );
          } catch (_) {
            await tokens.clear();
            onSessionExpired?.call();
            rethrow;
          }
        }
        await tokens.clear();
        onSessionExpired?.call();
      }
      if (error.error is ApiException) throw error.error as ApiException;
      final body = error.response?.data;
      if (body is Map) throw ApiException.fromResponse(body);
      throw ApiException(
        error.message ?? 'Network request failed',
        'NETWORK_ERROR',
      );
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async =>
      Map<String, dynamic>.from(
        await _request(
              'POST',
              '/auth/login',
              data: {'email': email, 'password': password},
              authenticated: false,
            )
            as Map,
      );
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String currency,
  ) async => Map<String, dynamic>.from(
    await _request(
          'POST',
          '/auth/register',
          data: {
            'name': name,
            'email': email,
            'password': password,
            'preferredCurrency': currency,
          },
          authenticated: false,
        )
        as Map,
  );
  Future<Map<String, dynamic>> refresh() async {
    final token = await tokens.refreshToken;
    if (token == null)
      throw ApiException('Your session has expired', 'INVALID_REFRESH_TOKEN');
    final value = Map<String, dynamic>.from(
      await _request(
            'POST',
            '/auth/refresh',
            data: {'refreshToken': token},
            authenticated: false,
          )
          as Map,
    );
    await tokens.saveSession(
      Session.fromJson(Map<String, dynamic>.from(value['session'] as Map)),
    );
    return value;
  }

  Future<Map<String, dynamic>> me() async =>
      Map<String, dynamic>.from(await _request('GET', '/auth/me') as Map);
  Future<User> userModel() async => User.fromJson(await me());
  Future<void> logout() async {
    final token = await tokens.refreshToken;
    try {
      if (token != null)
        await _request(
          'POST',
          '/auth/logout',
          data: {'refreshToken': token},
          authenticated: false,
        );
    } finally {
      await tokens.clear();
    }
  }

  Future<List<dynamic>> accounts() async =>
      List<dynamic>.from(await _request('GET', '/accounts') as List);
  Future<List<Account>> accountModels() async => (await accounts())
      .map((item) => Account.fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
  Future<List<dynamic>> wallets({String? accountId}) async =>
      List<dynamic>.from(
        await _request(
              'GET',
              '/wallets',
              query: accountId == null ? null : {'accountId': accountId},
            )
            as List,
      );
  Future<List<Wallet>> walletModels({String? accountId}) async =>
      (await wallets(accountId: accountId))
          .map(
            (item) => Wallet.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
  Future<List<dynamic>> categories({String? appliesTo}) async =>
      List<dynamic>.from(
        await _request(
              'GET',
              '/categories',
              query: appliesTo == null ? null : {'appliesTo': appliesTo},
            )
            as List,
      );
  Future<List<Category>> categoryModels({String? appliesTo}) async =>
      (await categories(appliesTo: appliesTo))
          .map(
            (item) => Category.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
  Future<Category> category(String id) async => Category.fromJson(
    Map<String, dynamic>.from(await _request('GET', '/categories/$id') as Map),
  );
  Future<List<dynamic>> walletTypes() async =>
      List<dynamic>.from(await _request('GET', '/wallet-types') as List);
  Future<Map<String, dynamic>> preferences() async => Map<String, dynamic>.from(
    await _request('GET', '/users/me/preferences') as Map,
  );
  Future<Map<String, dynamic>> updatePreferences(
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request('PATCH', '/users/me/preferences', data: data) as Map,
  );
  Future<Map<String, dynamic>> dashboard(
    int year,
    int month, {
    String? accountId,
    String? currencyCode,
  }) async => Map<String, dynamic>.from(
    await _request(
          'GET',
          '/dashboard',
          query: {
            'year': year,
            'month': month,
            if (accountId != null) 'accountId': accountId,
            if (currencyCode != null) 'currencyCode': currencyCode,
          },
        )
        as Map,
  );
  Future<Dashboard> dashboardModel(
    int year,
    int month, {
    String? accountId,
    String? currencyCode,
  }) async => Dashboard.fromJson(
    await dashboard(
      year,
      month,
      accountId: accountId,
      currencyCode: currencyCode,
    ),
  );
  Future<List<dynamic>> transactions(
    int year,
    int month, {
    String? type,
    String? accountId,
    String? walletId,
    String? categoryId,
    int limit = 100,
    int offset = 0,
  }) async => List<dynamic>.from(
    await _request(
          'GET',
          '/transactions',
          query: {
            'year': year,
            'month': month,
            'limit': limit,
            'offset': offset,
            if (type != null) 'type': type,
            if (accountId != null) 'accountId': accountId,
            if (walletId != null) 'walletId': walletId,
            if (categoryId != null) 'categoryId': categoryId,
          },
        )
        as List,
  );
  Future<TransactionPage> transactionsPage(
    int year,
    int month, {
    String? type,
    String? accountId,
    String? walletId,
    String? categoryId,
    int limit = 100,
    int offset = 0,
  }) async {
    final items = await transactions(
      year,
      month,
      type: type,
      accountId: accountId,
      walletId: walletId,
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
    return TransactionPage(
      items: items
          .map(
            (item) => TransactionItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      limit: limit,
      offset: offset,
    );
  }

  Future<Map<String, dynamic>> createTransaction(
    TransactionRequest request,
  ) async => Map<String, dynamic>.from(
    await _request('POST', '/transactions', data: request.toJson()) as Map,
  );
  Future<Map<String, dynamic>> transaction(String id) async =>
      Map<String, dynamic>.from(
        await _request('GET', '/transactions/$id') as Map,
      );
  Future<TransactionItem> transactionModel(String id) async =>
      TransactionItem.fromJson(await transaction(id));
  Future<Map<String, dynamic>> updateTransaction(
    String id,
    TransactionRequest request,
  ) async => Map<String, dynamic>.from(
    await _request('PATCH', '/transactions/$id', data: request.toJson()) as Map,
  );
  Future<void> voidTransaction(String id) async {
    await _request('DELETE', '/transactions/$id');
  }

  Future<Map<String, dynamic>> createAccount(Map<String, dynamic> data) async =>
      Map<String, dynamic>.from(
        await _request('POST', '/accounts', data: data) as Map,
      );
  Future<Map<String, dynamic>> updateAccount(
    String id,
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request('PATCH', '/accounts/$id', data: data) as Map,
  );
  Future<void> archiveAccount(String id) async {
    await _request('DELETE', '/accounts/$id');
  }

  Future<Map<String, dynamic>> createWallet(Map<String, dynamic> data) async =>
      Map<String, dynamic>.from(
        await _request(
              'POST',
              '/wallets',
              data: {
                ...data,
                if (data.containsKey('openingBalance'))
                  'openingBalance': _moneyForApi(
                    data['openingBalance'],
                    field: 'Opening balance',
                  ),
              },
            )
            as Map,
      );
  Future<Map<String, dynamic>> updateWallet(
    String id,
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request(
          'PATCH',
          '/wallets/$id',
          data: {
            ...data,
            if (data.containsKey('openingBalance'))
              'openingBalance': _moneyForApi(
                data['openingBalance'],
                field: 'Opening balance',
              ),
          },
        )
        as Map,
  );
  Future<void> archiveWallet(String id) async {
    await _request('DELETE', '/wallets/$id');
  }

  Future<Map<String, dynamic>> createCategory(
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request('POST', '/categories', data: data) as Map,
  );
  Future<Map<String, dynamic>> updateCategory(
    String id,
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request('PATCH', '/categories/$id', data: data) as Map,
  );
  Future<void> archiveCategory(String id) async {
    await _request('DELETE', '/categories/$id');
  }

  Future<Map<String, dynamic>> createTemplate(
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request(
          'POST',
          '/static-expenses',
          data: {
            ...data,
            if (data.containsKey('defaultAmount'))
              'defaultAmount': _moneyForApi(
                data['defaultAmount'],
                field: 'Amount',
                positive: true,
              ),
          },
        )
        as Map,
  );
  Future<Map<String, dynamic>> staticExpenses(int year, int month) async =>
      Map<String, dynamic>.from(
        await _request(
              'GET',
              '/static-expenses',
              query: {'year': year, 'month': month},
            )
            as Map,
      );
  Future<StaticExpenseCollection> staticExpensesModel(
    int year,
    int month,
  ) async =>
      StaticExpenseCollection.fromJson(await staticExpenses(year, month));
  Future<StaticExpenseTemplate> template(String id) async =>
      StaticExpenseTemplate.fromJson(
        Map<String, dynamic>.from(
          await _request('GET', '/static-expenses/$id') as Map,
        ),
      );
  Future<Map<String, dynamic>> updateTemplate(
    String id,
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request(
          'PATCH',
          '/static-expenses/$id',
          data: {
            ...data,
            if (data.containsKey('defaultAmount'))
              'defaultAmount': _moneyForApi(
                data['defaultAmount'],
                field: 'Amount',
                positive: true,
              ),
          },
        )
        as Map,
  );
  Future<void> archiveTemplate(String id) async {
    await _request('DELETE', '/static-expenses/$id');
  }

  Future<Map<String, dynamic>> payOccurrence(
    String id,
    OccurrencePaymentRequest request,
  ) async => Map<String, dynamic>.from(
    await _request(
          'POST',
          '/static-expenses/occurrences/$id/pay',
          data: request.toJson(),
        )
        as Map,
  );
  Future<void> skipOccurrence(String id) async {
    await _request('POST', '/static-expenses/occurrences/$id/skip');
  }

  Future<Map<String, dynamic>> updatePlan(Map<String, dynamic> data) async =>
      Map<String, dynamic>.from(
        await _request(
              'POST',
              '/monthly-plans',
              data: {
                ...data,
                if (data.containsKey('monthlyAllowance'))
                  'monthlyAllowance': _moneyForApi(
                    data['monthlyAllowance'],
                    field: 'Monthly allowance',
                  ),
              },
            )
            as Map,
      );
  Future<Map<String, dynamic>> monthlyPlan(
    int year,
    int month, {
    String? currencyCode,
  }) async => Map<String, dynamic>.from(
    await _request(
          'GET',
          '/monthly-plans/$year/$month',
          query: {if (currencyCode != null) 'currencyCode': currencyCode},
        )
        as Map,
  );
  Future<Map<String, dynamic>> createTransfer(
    Map<String, dynamic> data,
  ) async => Map<String, dynamic>.from(
    await _request(
          'POST',
          '/transfers',
          data: {
            ...data,
            if (data.containsKey('amount'))
              'amount': _moneyForApi(
                data['amount'],
                field: 'Amount',
                positive: true,
              ),
          },
        )
        as Map,
  );
  Future<List<dynamic>> transfers(int year, int month) async =>
      List<dynamic>.from(
        await _request(
              'GET',
              '/transfers',
              query: {'year': year, 'month': month},
            )
            as List,
      );
  Future<List<Transfer>> transferModels(int year, int month) async =>
      (await transfers(year, month))
          .map(
            (item) => Transfer.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
  Future<void> voidTransfer(String id) async {
    await _request('DELETE', '/transfers/$id');
  }

  Future<Transfer> transfer(String id) async => Transfer.fromJson(
    Map<String, dynamic>.from(await _request('GET', '/transfers/$id') as Map),
  );
}
