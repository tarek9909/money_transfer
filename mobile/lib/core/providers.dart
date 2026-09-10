import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'models.dart';

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => const TokenStore(FlutterSecureStorage()),
);
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    ref.watch(tokenStoreProvider),
    onSessionExpired: () => ref.read(authProvider.notifier).clearSession(),
  ),
);

class AuthController extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  Future<Map<String, dynamic>?> build() async {
    if (await ref.read(tokenStoreProvider).accessToken == null) return null;
    try {
      return await ref.read(apiClientProvider).me();
    } catch (_) {
      await ref.read(tokenStoreProvider).clear();
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final response = await ref.read(apiClientProvider).login(email, password);
      final session = Session.fromJson(
        Map<String, dynamic>.from(response['session'] as Map),
      );
      final user = User.fromJson(
        Map<String, dynamic>.from(response['user'] as Map),
      );
      await ref.read(tokenStoreProvider).saveSession(session);
      state = AsyncData(user.toJson());
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String currency,
  ) async {
    state = const AsyncLoading();
    try {
      final response = await ref
          .read(apiClientProvider)
          .register(name, email, password, currency);
      final session = Session.fromJson(
        Map<String, dynamic>.from(response['session'] as Map),
      );
      final user = User.fromJson(
        Map<String, dynamic>.from(response['user'] as Map),
      );
      await ref.read(tokenStoreProvider).saveSession(session);
      state = AsyncData(user.toJson());
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> logout() async {
    await ref.read(apiClientProvider).logout();
    state = const AsyncData(null);
  }

  void clearSession() {
    state = const AsyncData(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthController, Map<String, dynamic>?>(
      AuthController.new,
    );
final accountsProvider = FutureProvider<List<dynamic>>(
  (ref) => ref.watch(apiClientProvider).accounts(),
);
final walletsProvider = FutureProvider<List<dynamic>>(
  (ref) => ref.watch(apiClientProvider).wallets(),
);
final categoriesProvider = FutureProvider<List<dynamic>>(
  (ref) => ref.watch(apiClientProvider).categories(appliesTo: 'SPENDING'),
);
final incomeCategoriesProvider = FutureProvider<List<dynamic>>(
  (ref) => ref.watch(apiClientProvider).categories(appliesTo: 'INCOME'),
);
final preferencesProvider = FutureProvider<Map<String, dynamic>>(
  (ref) => ref.watch(apiClientProvider).preferences(),
);
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

final selectedPeriodProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);
final selectedAccountProvider = StateProvider<String?>((ref) => null);

class DashboardQuery {
  const DashboardQuery(this.year, this.month, this.accountId);
  final int year;
  final int month;
  final String? accountId;
  @override
  bool operator ==(Object other) =>
      other is DashboardQuery &&
      other.year == year &&
      other.month == month &&
      other.accountId == accountId;
  @override
  int get hashCode => Object.hash(year, month, accountId);
}

final dashboardProvider = FutureProvider.family<Dashboard, DashboardQuery>(
  (ref, query) => ref
      .watch(apiClientProvider)
      .dashboardModel(query.year, query.month, accountId: query.accountId),
);

class HistoryQuery {
  const HistoryQuery(this.year, this.month, this.type);
  final int year;
  final int month;
  final String? type;
  @override
  bool operator ==(Object other) =>
      other is HistoryQuery &&
      other.year == year &&
      other.month == month &&
      other.type == type;
  @override
  int get hashCode => Object.hash(year, month, type);
}

final transactionsProvider = FutureProvider.family<List<dynamic>, HistoryQuery>(
  (ref, query) => ref
      .watch(apiClientProvider)
      .transactions(query.year, query.month, type: query.type),
);

class TransactionHistory {
  const TransactionHistory({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<TransactionItem> items;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;

  TransactionHistory copyWith({
    List<TransactionItem>? items,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError = _keepError,
  }) => TransactionHistory(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: identical(loadMoreError, _keepError)
        ? this.loadMoreError
        : loadMoreError,
  );
}

const _keepError = Object();

class TransactionsController
    extends FamilyAsyncNotifier<TransactionHistory, HistoryQuery> {
  late HistoryQuery _query;

  @override
  Future<TransactionHistory> build(HistoryQuery arg) async {
    _query = arg;
    final page = await ref
        .read(apiClientProvider)
        .transactionsPage(arg.year, arg.month, type: arg.type, limit: 50);
    return TransactionHistory(items: page.items, hasMore: page.hasMore);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );
    try {
      final page = await ref
          .read(apiClientProvider)
          .transactionsPage(
            _query.year,
            _query.month,
            type: _query.type,
            limit: 50,
            offset: current.items.length,
          );
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }
}

final pagedTransactionsProvider =
    AsyncNotifierProviderFamily<
      TransactionsController,
      TransactionHistory,
      HistoryQuery
    >(TransactionsController.new);

class MonthQuery {
  const MonthQuery(this.year, this.month);
  final int year;
  final int month;
  @override
  bool operator ==(Object other) =>
      other is MonthQuery && other.year == year && other.month == month;
  @override
  int get hashCode => Object.hash(year, month);
}

final staticExpensesProvider =
    FutureProvider.family<StaticExpenseCollection, MonthQuery>(
      (ref, query) => ref
          .watch(apiClientProvider)
          .staticExpensesModel(query.year, query.month),
    );

final transfersProvider = FutureProvider.family<List<Transfer>, MonthQuery>(
  (ref, query) =>
      ref.watch(apiClientProvider).transferModels(query.year, query.month),
);
