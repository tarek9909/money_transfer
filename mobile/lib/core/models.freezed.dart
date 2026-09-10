// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

 String get accessToken; String get refreshToken; String get expiresIn;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresIn);

@override
String toString() {
  return 'Session(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String expiresIn
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String expiresIn)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  String expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({required this.accessToken, required this.refreshToken, required this.expiresIn});
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  String expiresIn;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresIn);

@override
String toString() {
  return 'Session(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, String expiresIn
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,}) {
  return _then(_Session(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$User {

 String get id; String get name; String get email; String get preferredCurrency; String get timezone;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.preferredCurrency, preferredCurrency) || other.preferredCurrency == preferredCurrency)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,preferredCurrency,timezone);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, preferredCurrency: $preferredCurrency, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String preferredCurrency, String timezone
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? preferredCurrency = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,preferredCurrency: null == preferredCurrency ? _self.preferredCurrency : preferredCurrency // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String preferredCurrency,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.preferredCurrency,_that.timezone);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String preferredCurrency,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.preferredCurrency,_that.timezone);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String preferredCurrency,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.preferredCurrency,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.name, required this.email, required this.preferredCurrency, required this.timezone});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String preferredCurrency;
@override final  String timezone;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.preferredCurrency, preferredCurrency) || other.preferredCurrency == preferredCurrency)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,preferredCurrency,timezone);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, preferredCurrency: $preferredCurrency, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String preferredCurrency, String timezone
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? preferredCurrency = null,Object? timezone = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,preferredCurrency: null == preferredCurrency ? _self.preferredCurrency : preferredCurrency // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Wallet {

 String get id; String get accountId; String? get accountName; String get name; String get walletTypeCode; String get currencyCode;@DecimalConverter() Decimal get openingBalance;@DecimalConverter() Decimal get currentBalance; bool get isActive;
/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletCopyWith<Wallet> get copyWith => _$WalletCopyWithImpl<Wallet>(this as Wallet, _$identity);

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wallet&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.name, name) || other.name == name)&&(identical(other.walletTypeCode, walletTypeCode) || other.walletTypeCode == walletTypeCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountName,name,walletTypeCode,currencyCode,openingBalance,currentBalance,isActive);

@override
String toString() {
  return 'Wallet(id: $id, accountId: $accountId, accountName: $accountName, name: $name, walletTypeCode: $walletTypeCode, currencyCode: $currencyCode, openingBalance: $openingBalance, currentBalance: $currentBalance, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $WalletCopyWith<$Res>  {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) _then) = _$WalletCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, String? accountName, String name, String walletTypeCode, String currencyCode,@DecimalConverter() Decimal openingBalance,@DecimalConverter() Decimal currentBalance, bool isActive
});




}
/// @nodoc
class _$WalletCopyWithImpl<$Res>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._self, this._then);

  final Wallet _self;
  final $Res Function(Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? accountName = freezed,Object? name = null,Object? walletTypeCode = null,Object? currencyCode = null,Object? openingBalance = null,Object? currentBalance = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,walletTypeCode: null == walletTypeCode ? _self.walletTypeCode : walletTypeCode // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as Decimal,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as Decimal,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Wallet].
extension WalletPatterns on Wallet {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wallet value)  $default,){
final _that = this;
switch (_that) {
case _Wallet():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wallet value)?  $default,){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String accountId,  String? accountName,  String name,  String walletTypeCode,  String currencyCode, @DecimalConverter()  Decimal openingBalance, @DecimalConverter()  Decimal currentBalance,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.accountId,_that.accountName,_that.name,_that.walletTypeCode,_that.currencyCode,_that.openingBalance,_that.currentBalance,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String accountId,  String? accountName,  String name,  String walletTypeCode,  String currencyCode, @DecimalConverter()  Decimal openingBalance, @DecimalConverter()  Decimal currentBalance,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Wallet():
return $default(_that.id,_that.accountId,_that.accountName,_that.name,_that.walletTypeCode,_that.currencyCode,_that.openingBalance,_that.currentBalance,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String accountId,  String? accountName,  String name,  String walletTypeCode,  String currencyCode, @DecimalConverter()  Decimal openingBalance, @DecimalConverter()  Decimal currentBalance,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.accountId,_that.accountName,_that.name,_that.walletTypeCode,_that.currencyCode,_that.openingBalance,_that.currentBalance,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wallet implements Wallet {
  const _Wallet({required this.id, required this.accountId, this.accountName, required this.name, required this.walletTypeCode, required this.currencyCode, @DecimalConverter() required this.openingBalance, @DecimalConverter() required this.currentBalance, required this.isActive});
  factory _Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

@override final  String id;
@override final  String accountId;
@override final  String? accountName;
@override final  String name;
@override final  String walletTypeCode;
@override final  String currencyCode;
@override@DecimalConverter() final  Decimal openingBalance;
@override@DecimalConverter() final  Decimal currentBalance;
@override final  bool isActive;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletCopyWith<_Wallet> get copyWith => __$WalletCopyWithImpl<_Wallet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wallet&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.name, name) || other.name == name)&&(identical(other.walletTypeCode, walletTypeCode) || other.walletTypeCode == walletTypeCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountName,name,walletTypeCode,currencyCode,openingBalance,currentBalance,isActive);

@override
String toString() {
  return 'Wallet(id: $id, accountId: $accountId, accountName: $accountName, name: $name, walletTypeCode: $walletTypeCode, currencyCode: $currencyCode, openingBalance: $openingBalance, currentBalance: $currentBalance, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$WalletCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$WalletCopyWith(_Wallet value, $Res Function(_Wallet) _then) = __$WalletCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, String? accountName, String name, String walletTypeCode, String currencyCode,@DecimalConverter() Decimal openingBalance,@DecimalConverter() Decimal currentBalance, bool isActive
});




}
/// @nodoc
class __$WalletCopyWithImpl<$Res>
    implements _$WalletCopyWith<$Res> {
  __$WalletCopyWithImpl(this._self, this._then);

  final _Wallet _self;
  final $Res Function(_Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? accountName = freezed,Object? name = null,Object? walletTypeCode = null,Object? currencyCode = null,Object? openingBalance = null,Object? currentBalance = null,Object? isActive = null,}) {
  return _then(_Wallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,walletTypeCode: null == walletTypeCode ? _self.walletTypeCode : walletTypeCode // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as Decimal,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as Decimal,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Account {

 String get id; String get name; String? get description; String? get parentAccountId; bool get isActive; List<Wallet> get wallets;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentAccountId, parentAccountId) || other.parentAccountId == parentAccountId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.wallets, wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,parentAccountId,isActive,const DeepCollectionEquality().hash(wallets));

@override
String toString() {
  return 'Account(id: $id, name: $name, description: $description, parentAccountId: $parentAccountId, isActive: $isActive, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? parentAccountId, bool isActive, List<Wallet> wallets
});




}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? parentAccountId = freezed,Object? isActive = null,Object? wallets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentAccountId: freezed == parentAccountId ? _self.parentAccountId : parentAccountId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}

}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? parentAccountId,  bool isActive,  List<Wallet> wallets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.parentAccountId,_that.isActive,_that.wallets);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? parentAccountId,  bool isActive,  List<Wallet> wallets)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.id,_that.name,_that.description,_that.parentAccountId,_that.isActive,_that.wallets);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? parentAccountId,  bool isActive,  List<Wallet> wallets)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.parentAccountId,_that.isActive,_that.wallets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Account implements Account {
  const _Account({required this.id, required this.name, this.description, this.parentAccountId, required this.isActive, final  List<Wallet> wallets = const <Wallet>[]}): _wallets = wallets;
  factory _Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? parentAccountId;
@override final  bool isActive;
 final  List<Wallet> _wallets;
@override@JsonKey() List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentAccountId, parentAccountId) || other.parentAccountId == parentAccountId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._wallets, _wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,parentAccountId,isActive,const DeepCollectionEquality().hash(_wallets));

@override
String toString() {
  return 'Account(id: $id, name: $name, description: $description, parentAccountId: $parentAccountId, isActive: $isActive, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? parentAccountId, bool isActive, List<Wallet> wallets
});




}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? parentAccountId = freezed,Object? isActive = null,Object? wallets = null,}) {
  return _then(_Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentAccountId: freezed == parentAccountId ? _self.parentAccountId : parentAccountId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}


/// @nodoc
mixin _$Category {

 String get id; String get name; String get appliesTo; bool get isActive; int get sortOrder;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.appliesTo, appliesTo) || other.appliesTo == appliesTo)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,appliesTo,isActive,sortOrder);

@override
String toString() {
  return 'Category(id: $id, name: $name, appliesTo: $appliesTo, isActive: $isActive, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String appliesTo, bool isActive, int sortOrder
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? appliesTo = null,Object? isActive = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,appliesTo: null == appliesTo ? _self.appliesTo : appliesTo // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String appliesTo,  bool isActive,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.appliesTo,_that.isActive,_that.sortOrder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String appliesTo,  bool isActive,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.name,_that.appliesTo,_that.isActive,_that.sortOrder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String appliesTo,  bool isActive,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.appliesTo,_that.isActive,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, required this.name, required this.appliesTo, required this.isActive, required this.sortOrder});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String appliesTo;
@override final  bool isActive;
@override final  int sortOrder;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.appliesTo, appliesTo) || other.appliesTo == appliesTo)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,appliesTo,isActive,sortOrder);

@override
String toString() {
  return 'Category(id: $id, name: $name, appliesTo: $appliesTo, isActive: $isActive, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String appliesTo, bool isActive, int sortOrder
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? appliesTo = null,Object? isActive = null,Object? sortOrder = null,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,appliesTo: null == appliesTo ? _self.appliesTo : appliesTo // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TransactionItem {

 String get id; String get transactionType;@DecimalConverter() Decimal get amount; String get currencyCode; String get accountId; String? get accountName; String get walletId; String? get walletName; String? get categoryId; String? get categoryName; String? get staticExpenseTemplateId; String? get description; String? get notes; String get transactionDate; String? get transactionTime; String get status; String? get createdAt;
/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionItemCopyWith<TransactionItem> get copyWith => _$TransactionItemCopyWithImpl<TransactionItem>(this as TransactionItem, _$identity);

  /// Serializes this TransactionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.staticExpenseTemplateId, staticExpenseTemplateId) || other.staticExpenseTemplateId == staticExpenseTemplateId)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.transactionTime, transactionTime) || other.transactionTime == transactionTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionType,amount,currencyCode,accountId,accountName,walletId,walletName,categoryId,categoryName,staticExpenseTemplateId,description,notes,transactionDate,transactionTime,status,createdAt);

@override
String toString() {
  return 'TransactionItem(id: $id, transactionType: $transactionType, amount: $amount, currencyCode: $currencyCode, accountId: $accountId, accountName: $accountName, walletId: $walletId, walletName: $walletName, categoryId: $categoryId, categoryName: $categoryName, staticExpenseTemplateId: $staticExpenseTemplateId, description: $description, notes: $notes, transactionDate: $transactionDate, transactionTime: $transactionTime, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionItemCopyWith<$Res>  {
  factory $TransactionItemCopyWith(TransactionItem value, $Res Function(TransactionItem) _then) = _$TransactionItemCopyWithImpl;
@useResult
$Res call({
 String id, String transactionType,@DecimalConverter() Decimal amount, String currencyCode, String accountId, String? accountName, String walletId, String? walletName, String? categoryId, String? categoryName, String? staticExpenseTemplateId, String? description, String? notes, String transactionDate, String? transactionTime, String status, String? createdAt
});




}
/// @nodoc
class _$TransactionItemCopyWithImpl<$Res>
    implements $TransactionItemCopyWith<$Res> {
  _$TransactionItemCopyWithImpl(this._self, this._then);

  final TransactionItem _self;
  final $Res Function(TransactionItem) _then;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionType = null,Object? amount = null,Object? currencyCode = null,Object? accountId = null,Object? accountName = freezed,Object? walletId = null,Object? walletName = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? staticExpenseTemplateId = freezed,Object? description = freezed,Object? notes = freezed,Object? transactionDate = null,Object? transactionTime = freezed,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,walletName: freezed == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,staticExpenseTemplateId: freezed == staticExpenseTemplateId ? _self.staticExpenseTemplateId : staticExpenseTemplateId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String,transactionTime: freezed == transactionTime ? _self.transactionTime : transactionTime // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionItem].
extension TransactionItemPatterns on TransactionItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionItem value)  $default,){
final _that = this;
switch (_that) {
case _TransactionItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String transactionType, @DecimalConverter()  Decimal amount,  String currencyCode,  String accountId,  String? accountName,  String walletId,  String? walletName,  String? categoryId,  String? categoryName,  String? staticExpenseTemplateId,  String? description,  String? notes,  String transactionDate,  String? transactionTime,  String status,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that.id,_that.transactionType,_that.amount,_that.currencyCode,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.categoryId,_that.categoryName,_that.staticExpenseTemplateId,_that.description,_that.notes,_that.transactionDate,_that.transactionTime,_that.status,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String transactionType, @DecimalConverter()  Decimal amount,  String currencyCode,  String accountId,  String? accountName,  String walletId,  String? walletName,  String? categoryId,  String? categoryName,  String? staticExpenseTemplateId,  String? description,  String? notes,  String transactionDate,  String? transactionTime,  String status,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionItem():
return $default(_that.id,_that.transactionType,_that.amount,_that.currencyCode,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.categoryId,_that.categoryName,_that.staticExpenseTemplateId,_that.description,_that.notes,_that.transactionDate,_that.transactionTime,_that.status,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String transactionType, @DecimalConverter()  Decimal amount,  String currencyCode,  String accountId,  String? accountName,  String walletId,  String? walletName,  String? categoryId,  String? categoryName,  String? staticExpenseTemplateId,  String? description,  String? notes,  String transactionDate,  String? transactionTime,  String status,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionItem() when $default != null:
return $default(_that.id,_that.transactionType,_that.amount,_that.currencyCode,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.categoryId,_that.categoryName,_that.staticExpenseTemplateId,_that.description,_that.notes,_that.transactionDate,_that.transactionTime,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionItem implements TransactionItem {
  const _TransactionItem({required this.id, required this.transactionType, @DecimalConverter() required this.amount, required this.currencyCode, required this.accountId, this.accountName, required this.walletId, this.walletName, this.categoryId, this.categoryName, this.staticExpenseTemplateId, this.description, this.notes, required this.transactionDate, this.transactionTime, required this.status, this.createdAt});
  factory _TransactionItem.fromJson(Map<String, dynamic> json) => _$TransactionItemFromJson(json);

@override final  String id;
@override final  String transactionType;
@override@DecimalConverter() final  Decimal amount;
@override final  String currencyCode;
@override final  String accountId;
@override final  String? accountName;
@override final  String walletId;
@override final  String? walletName;
@override final  String? categoryId;
@override final  String? categoryName;
@override final  String? staticExpenseTemplateId;
@override final  String? description;
@override final  String? notes;
@override final  String transactionDate;
@override final  String? transactionTime;
@override final  String status;
@override final  String? createdAt;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionItemCopyWith<_TransactionItem> get copyWith => __$TransactionItemCopyWithImpl<_TransactionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.staticExpenseTemplateId, staticExpenseTemplateId) || other.staticExpenseTemplateId == staticExpenseTemplateId)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.transactionTime, transactionTime) || other.transactionTime == transactionTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionType,amount,currencyCode,accountId,accountName,walletId,walletName,categoryId,categoryName,staticExpenseTemplateId,description,notes,transactionDate,transactionTime,status,createdAt);

@override
String toString() {
  return 'TransactionItem(id: $id, transactionType: $transactionType, amount: $amount, currencyCode: $currencyCode, accountId: $accountId, accountName: $accountName, walletId: $walletId, walletName: $walletName, categoryId: $categoryId, categoryName: $categoryName, staticExpenseTemplateId: $staticExpenseTemplateId, description: $description, notes: $notes, transactionDate: $transactionDate, transactionTime: $transactionTime, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionItemCopyWith<$Res> implements $TransactionItemCopyWith<$Res> {
  factory _$TransactionItemCopyWith(_TransactionItem value, $Res Function(_TransactionItem) _then) = __$TransactionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionType,@DecimalConverter() Decimal amount, String currencyCode, String accountId, String? accountName, String walletId, String? walletName, String? categoryId, String? categoryName, String? staticExpenseTemplateId, String? description, String? notes, String transactionDate, String? transactionTime, String status, String? createdAt
});




}
/// @nodoc
class __$TransactionItemCopyWithImpl<$Res>
    implements _$TransactionItemCopyWith<$Res> {
  __$TransactionItemCopyWithImpl(this._self, this._then);

  final _TransactionItem _self;
  final $Res Function(_TransactionItem) _then;

/// Create a copy of TransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionType = null,Object? amount = null,Object? currencyCode = null,Object? accountId = null,Object? accountName = freezed,Object? walletId = null,Object? walletName = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? staticExpenseTemplateId = freezed,Object? description = freezed,Object? notes = freezed,Object? transactionDate = null,Object? transactionTime = freezed,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_TransactionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,walletName: freezed == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,staticExpenseTemplateId: freezed == staticExpenseTemplateId ? _self.staticExpenseTemplateId : staticExpenseTemplateId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String,transactionTime: freezed == transactionTime ? _self.transactionTime : transactionTime // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StaticExpenseTemplate {

 String get id; String get name;@JsonKey(name: 'amount')@DecimalConverter() Decimal get amount; String get accountId; String get accountName; String? get defaultWalletId; String? get categoryId; String? get categoryName; int get dueDay; String get startDate; String? get endDate; String? get notes; bool get isActive;
/// Create a copy of StaticExpenseTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaticExpenseTemplateCopyWith<StaticExpenseTemplate> get copyWith => _$StaticExpenseTemplateCopyWithImpl<StaticExpenseTemplate>(this as StaticExpenseTemplate, _$identity);

  /// Serializes this StaticExpenseTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaticExpenseTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.defaultWalletId, defaultWalletId) || other.defaultWalletId == defaultWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.dueDay, dueDay) || other.dueDay == dueDay)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,accountId,accountName,defaultWalletId,categoryId,categoryName,dueDay,startDate,endDate,notes,isActive);

@override
String toString() {
  return 'StaticExpenseTemplate(id: $id, name: $name, amount: $amount, accountId: $accountId, accountName: $accountName, defaultWalletId: $defaultWalletId, categoryId: $categoryId, categoryName: $categoryName, dueDay: $dueDay, startDate: $startDate, endDate: $endDate, notes: $notes, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $StaticExpenseTemplateCopyWith<$Res>  {
  factory $StaticExpenseTemplateCopyWith(StaticExpenseTemplate value, $Res Function(StaticExpenseTemplate) _then) = _$StaticExpenseTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'amount')@DecimalConverter() Decimal amount, String accountId, String accountName, String? defaultWalletId, String? categoryId, String? categoryName, int dueDay, String startDate, String? endDate, String? notes, bool isActive
});




}
/// @nodoc
class _$StaticExpenseTemplateCopyWithImpl<$Res>
    implements $StaticExpenseTemplateCopyWith<$Res> {
  _$StaticExpenseTemplateCopyWithImpl(this._self, this._then);

  final StaticExpenseTemplate _self;
  final $Res Function(StaticExpenseTemplate) _then;

/// Create a copy of StaticExpenseTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? accountId = null,Object? accountName = null,Object? defaultWalletId = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? dueDay = null,Object? startDate = null,Object? endDate = freezed,Object? notes = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,defaultWalletId: freezed == defaultWalletId ? _self.defaultWalletId : defaultWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,dueDay: null == dueDay ? _self.dueDay : dueDay // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StaticExpenseTemplate].
extension StaticExpenseTemplatePatterns on StaticExpenseTemplate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaticExpenseTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaticExpenseTemplate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaticExpenseTemplate value)  $default,){
final _that = this;
switch (_that) {
case _StaticExpenseTemplate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaticExpenseTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _StaticExpenseTemplate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'amount')@DecimalConverter()  Decimal amount,  String accountId,  String accountName,  String? defaultWalletId,  String? categoryId,  String? categoryName,  int dueDay,  String startDate,  String? endDate,  String? notes,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaticExpenseTemplate() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.accountId,_that.accountName,_that.defaultWalletId,_that.categoryId,_that.categoryName,_that.dueDay,_that.startDate,_that.endDate,_that.notes,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'amount')@DecimalConverter()  Decimal amount,  String accountId,  String accountName,  String? defaultWalletId,  String? categoryId,  String? categoryName,  int dueDay,  String startDate,  String? endDate,  String? notes,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _StaticExpenseTemplate():
return $default(_that.id,_that.name,_that.amount,_that.accountId,_that.accountName,_that.defaultWalletId,_that.categoryId,_that.categoryName,_that.dueDay,_that.startDate,_that.endDate,_that.notes,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'amount')@DecimalConverter()  Decimal amount,  String accountId,  String accountName,  String? defaultWalletId,  String? categoryId,  String? categoryName,  int dueDay,  String startDate,  String? endDate,  String? notes,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _StaticExpenseTemplate() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.accountId,_that.accountName,_that.defaultWalletId,_that.categoryId,_that.categoryName,_that.dueDay,_that.startDate,_that.endDate,_that.notes,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaticExpenseTemplate implements StaticExpenseTemplate {
  const _StaticExpenseTemplate({required this.id, required this.name, @JsonKey(name: 'amount')@DecimalConverter() required this.amount, required this.accountId, required this.accountName, this.defaultWalletId, this.categoryId, this.categoryName, required this.dueDay, required this.startDate, this.endDate, this.notes, required this.isActive});
  factory _StaticExpenseTemplate.fromJson(Map<String, dynamic> json) => _$StaticExpenseTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'amount')@DecimalConverter() final  Decimal amount;
@override final  String accountId;
@override final  String accountName;
@override final  String? defaultWalletId;
@override final  String? categoryId;
@override final  String? categoryName;
@override final  int dueDay;
@override final  String startDate;
@override final  String? endDate;
@override final  String? notes;
@override final  bool isActive;

/// Create a copy of StaticExpenseTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaticExpenseTemplateCopyWith<_StaticExpenseTemplate> get copyWith => __$StaticExpenseTemplateCopyWithImpl<_StaticExpenseTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaticExpenseTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaticExpenseTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.defaultWalletId, defaultWalletId) || other.defaultWalletId == defaultWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.dueDay, dueDay) || other.dueDay == dueDay)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,accountId,accountName,defaultWalletId,categoryId,categoryName,dueDay,startDate,endDate,notes,isActive);

@override
String toString() {
  return 'StaticExpenseTemplate(id: $id, name: $name, amount: $amount, accountId: $accountId, accountName: $accountName, defaultWalletId: $defaultWalletId, categoryId: $categoryId, categoryName: $categoryName, dueDay: $dueDay, startDate: $startDate, endDate: $endDate, notes: $notes, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$StaticExpenseTemplateCopyWith<$Res> implements $StaticExpenseTemplateCopyWith<$Res> {
  factory _$StaticExpenseTemplateCopyWith(_StaticExpenseTemplate value, $Res Function(_StaticExpenseTemplate) _then) = __$StaticExpenseTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'amount')@DecimalConverter() Decimal amount, String accountId, String accountName, String? defaultWalletId, String? categoryId, String? categoryName, int dueDay, String startDate, String? endDate, String? notes, bool isActive
});




}
/// @nodoc
class __$StaticExpenseTemplateCopyWithImpl<$Res>
    implements _$StaticExpenseTemplateCopyWith<$Res> {
  __$StaticExpenseTemplateCopyWithImpl(this._self, this._then);

  final _StaticExpenseTemplate _self;
  final $Res Function(_StaticExpenseTemplate) _then;

/// Create a copy of StaticExpenseTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? accountId = null,Object? accountName = null,Object? defaultWalletId = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? dueDay = null,Object? startDate = null,Object? endDate = freezed,Object? notes = freezed,Object? isActive = null,}) {
  return _then(_StaticExpenseTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,defaultWalletId: freezed == defaultWalletId ? _self.defaultWalletId : defaultWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,dueDay: null == dueDay ? _self.dueDay : dueDay // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StaticExpenseOccurrence {

 String get id; String get templateId; String get name; String get accountId; String? get accountName; String? get walletId; String? get walletName; String? get currencyCode; String? get categoryId; int get dueYear; int get dueMonth; String get dueDate;@DecimalConverter() Decimal get expectedAmount; String get status; String? get paidTransactionId; String? get paidAt; String? get skippedAt; String? get notes;
/// Create a copy of StaticExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaticExpenseOccurrenceCopyWith<StaticExpenseOccurrence> get copyWith => _$StaticExpenseOccurrenceCopyWithImpl<StaticExpenseOccurrence>(this as StaticExpenseOccurrence, _$identity);

  /// Serializes this StaticExpenseOccurrence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaticExpenseOccurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.dueYear, dueYear) || other.dueYear == dueYear)&&(identical(other.dueMonth, dueMonth) || other.dueMonth == dueMonth)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidTransactionId, paidTransactionId) || other.paidTransactionId == paidTransactionId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.skippedAt, skippedAt) || other.skippedAt == skippedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,templateId,name,accountId,accountName,walletId,walletName,currencyCode,categoryId,dueYear,dueMonth,dueDate,expectedAmount,status,paidTransactionId,paidAt,skippedAt,notes);

@override
String toString() {
  return 'StaticExpenseOccurrence(id: $id, templateId: $templateId, name: $name, accountId: $accountId, accountName: $accountName, walletId: $walletId, walletName: $walletName, currencyCode: $currencyCode, categoryId: $categoryId, dueYear: $dueYear, dueMonth: $dueMonth, dueDate: $dueDate, expectedAmount: $expectedAmount, status: $status, paidTransactionId: $paidTransactionId, paidAt: $paidAt, skippedAt: $skippedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $StaticExpenseOccurrenceCopyWith<$Res>  {
  factory $StaticExpenseOccurrenceCopyWith(StaticExpenseOccurrence value, $Res Function(StaticExpenseOccurrence) _then) = _$StaticExpenseOccurrenceCopyWithImpl;
@useResult
$Res call({
 String id, String templateId, String name, String accountId, String? accountName, String? walletId, String? walletName, String? currencyCode, String? categoryId, int dueYear, int dueMonth, String dueDate,@DecimalConverter() Decimal expectedAmount, String status, String? paidTransactionId, String? paidAt, String? skippedAt, String? notes
});




}
/// @nodoc
class _$StaticExpenseOccurrenceCopyWithImpl<$Res>
    implements $StaticExpenseOccurrenceCopyWith<$Res> {
  _$StaticExpenseOccurrenceCopyWithImpl(this._self, this._then);

  final StaticExpenseOccurrence _self;
  final $Res Function(StaticExpenseOccurrence) _then;

/// Create a copy of StaticExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? templateId = null,Object? name = null,Object? accountId = null,Object? accountName = freezed,Object? walletId = freezed,Object? walletName = freezed,Object? currencyCode = freezed,Object? categoryId = freezed,Object? dueYear = null,Object? dueMonth = null,Object? dueDate = null,Object? expectedAmount = null,Object? status = null,Object? paidTransactionId = freezed,Object? paidAt = freezed,Object? skippedAt = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,walletName: freezed == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,dueYear: null == dueYear ? _self.dueYear : dueYear // ignore: cast_nullable_to_non_nullable
as int,dueMonth: null == dueMonth ? _self.dueMonth : dueMonth // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidTransactionId: freezed == paidTransactionId ? _self.paidTransactionId : paidTransactionId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,skippedAt: freezed == skippedAt ? _self.skippedAt : skippedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StaticExpenseOccurrence].
extension StaticExpenseOccurrencePatterns on StaticExpenseOccurrence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaticExpenseOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaticExpenseOccurrence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaticExpenseOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _StaticExpenseOccurrence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaticExpenseOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _StaticExpenseOccurrence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String templateId,  String name,  String accountId,  String? accountName,  String? walletId,  String? walletName,  String? currencyCode,  String? categoryId,  int dueYear,  int dueMonth,  String dueDate, @DecimalConverter()  Decimal expectedAmount,  String status,  String? paidTransactionId,  String? paidAt,  String? skippedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaticExpenseOccurrence() when $default != null:
return $default(_that.id,_that.templateId,_that.name,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.currencyCode,_that.categoryId,_that.dueYear,_that.dueMonth,_that.dueDate,_that.expectedAmount,_that.status,_that.paidTransactionId,_that.paidAt,_that.skippedAt,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String templateId,  String name,  String accountId,  String? accountName,  String? walletId,  String? walletName,  String? currencyCode,  String? categoryId,  int dueYear,  int dueMonth,  String dueDate, @DecimalConverter()  Decimal expectedAmount,  String status,  String? paidTransactionId,  String? paidAt,  String? skippedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _StaticExpenseOccurrence():
return $default(_that.id,_that.templateId,_that.name,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.currencyCode,_that.categoryId,_that.dueYear,_that.dueMonth,_that.dueDate,_that.expectedAmount,_that.status,_that.paidTransactionId,_that.paidAt,_that.skippedAt,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String templateId,  String name,  String accountId,  String? accountName,  String? walletId,  String? walletName,  String? currencyCode,  String? categoryId,  int dueYear,  int dueMonth,  String dueDate, @DecimalConverter()  Decimal expectedAmount,  String status,  String? paidTransactionId,  String? paidAt,  String? skippedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _StaticExpenseOccurrence() when $default != null:
return $default(_that.id,_that.templateId,_that.name,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.currencyCode,_that.categoryId,_that.dueYear,_that.dueMonth,_that.dueDate,_that.expectedAmount,_that.status,_that.paidTransactionId,_that.paidAt,_that.skippedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaticExpenseOccurrence implements StaticExpenseOccurrence {
  const _StaticExpenseOccurrence({required this.id, required this.templateId, required this.name, required this.accountId, this.accountName, this.walletId, this.walletName, this.currencyCode, this.categoryId, required this.dueYear, required this.dueMonth, required this.dueDate, @DecimalConverter() required this.expectedAmount, required this.status, this.paidTransactionId, this.paidAt, this.skippedAt, this.notes});
  factory _StaticExpenseOccurrence.fromJson(Map<String, dynamic> json) => _$StaticExpenseOccurrenceFromJson(json);

@override final  String id;
@override final  String templateId;
@override final  String name;
@override final  String accountId;
@override final  String? accountName;
@override final  String? walletId;
@override final  String? walletName;
@override final  String? currencyCode;
@override final  String? categoryId;
@override final  int dueYear;
@override final  int dueMonth;
@override final  String dueDate;
@override@DecimalConverter() final  Decimal expectedAmount;
@override final  String status;
@override final  String? paidTransactionId;
@override final  String? paidAt;
@override final  String? skippedAt;
@override final  String? notes;

/// Create a copy of StaticExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaticExpenseOccurrenceCopyWith<_StaticExpenseOccurrence> get copyWith => __$StaticExpenseOccurrenceCopyWithImpl<_StaticExpenseOccurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaticExpenseOccurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaticExpenseOccurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.dueYear, dueYear) || other.dueYear == dueYear)&&(identical(other.dueMonth, dueMonth) || other.dueMonth == dueMonth)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidTransactionId, paidTransactionId) || other.paidTransactionId == paidTransactionId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.skippedAt, skippedAt) || other.skippedAt == skippedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,templateId,name,accountId,accountName,walletId,walletName,currencyCode,categoryId,dueYear,dueMonth,dueDate,expectedAmount,status,paidTransactionId,paidAt,skippedAt,notes);

@override
String toString() {
  return 'StaticExpenseOccurrence(id: $id, templateId: $templateId, name: $name, accountId: $accountId, accountName: $accountName, walletId: $walletId, walletName: $walletName, currencyCode: $currencyCode, categoryId: $categoryId, dueYear: $dueYear, dueMonth: $dueMonth, dueDate: $dueDate, expectedAmount: $expectedAmount, status: $status, paidTransactionId: $paidTransactionId, paidAt: $paidAt, skippedAt: $skippedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$StaticExpenseOccurrenceCopyWith<$Res> implements $StaticExpenseOccurrenceCopyWith<$Res> {
  factory _$StaticExpenseOccurrenceCopyWith(_StaticExpenseOccurrence value, $Res Function(_StaticExpenseOccurrence) _then) = __$StaticExpenseOccurrenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String templateId, String name, String accountId, String? accountName, String? walletId, String? walletName, String? currencyCode, String? categoryId, int dueYear, int dueMonth, String dueDate,@DecimalConverter() Decimal expectedAmount, String status, String? paidTransactionId, String? paidAt, String? skippedAt, String? notes
});




}
/// @nodoc
class __$StaticExpenseOccurrenceCopyWithImpl<$Res>
    implements _$StaticExpenseOccurrenceCopyWith<$Res> {
  __$StaticExpenseOccurrenceCopyWithImpl(this._self, this._then);

  final _StaticExpenseOccurrence _self;
  final $Res Function(_StaticExpenseOccurrence) _then;

/// Create a copy of StaticExpenseOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? templateId = null,Object? name = null,Object? accountId = null,Object? accountName = freezed,Object? walletId = freezed,Object? walletName = freezed,Object? currencyCode = freezed,Object? categoryId = freezed,Object? dueYear = null,Object? dueMonth = null,Object? dueDate = null,Object? expectedAmount = null,Object? status = null,Object? paidTransactionId = freezed,Object? paidAt = freezed,Object? skippedAt = freezed,Object? notes = freezed,}) {
  return _then(_StaticExpenseOccurrence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,walletName: freezed == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,dueYear: null == dueYear ? _self.dueYear : dueYear // ignore: cast_nullable_to_non_nullable
as int,dueMonth: null == dueMonth ? _self.dueMonth : dueMonth // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as Decimal,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidTransactionId: freezed == paidTransactionId ? _self.paidTransactionId : paidTransactionId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,skippedAt: freezed == skippedAt ? _self.skippedAt : skippedAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StaticExpenseCollection {

 int get year; int get month; List<StaticExpenseTemplate> get templates; List<StaticExpenseOccurrence> get occurrences;
/// Create a copy of StaticExpenseCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaticExpenseCollectionCopyWith<StaticExpenseCollection> get copyWith => _$StaticExpenseCollectionCopyWithImpl<StaticExpenseCollection>(this as StaticExpenseCollection, _$identity);

  /// Serializes this StaticExpenseCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaticExpenseCollection&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.templates, templates)&&const DeepCollectionEquality().equals(other.occurrences, occurrences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(templates),const DeepCollectionEquality().hash(occurrences));

@override
String toString() {
  return 'StaticExpenseCollection(year: $year, month: $month, templates: $templates, occurrences: $occurrences)';
}


}

/// @nodoc
abstract mixin class $StaticExpenseCollectionCopyWith<$Res>  {
  factory $StaticExpenseCollectionCopyWith(StaticExpenseCollection value, $Res Function(StaticExpenseCollection) _then) = _$StaticExpenseCollectionCopyWithImpl;
@useResult
$Res call({
 int year, int month, List<StaticExpenseTemplate> templates, List<StaticExpenseOccurrence> occurrences
});




}
/// @nodoc
class _$StaticExpenseCollectionCopyWithImpl<$Res>
    implements $StaticExpenseCollectionCopyWith<$Res> {
  _$StaticExpenseCollectionCopyWithImpl(this._self, this._then);

  final StaticExpenseCollection _self;
  final $Res Function(StaticExpenseCollection) _then;

/// Create a copy of StaticExpenseCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? templates = null,Object? occurrences = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as List<StaticExpenseTemplate>,occurrences: null == occurrences ? _self.occurrences : occurrences // ignore: cast_nullable_to_non_nullable
as List<StaticExpenseOccurrence>,
  ));
}

}


/// Adds pattern-matching-related methods to [StaticExpenseCollection].
extension StaticExpenseCollectionPatterns on StaticExpenseCollection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaticExpenseCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaticExpenseCollection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaticExpenseCollection value)  $default,){
final _that = this;
switch (_that) {
case _StaticExpenseCollection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaticExpenseCollection value)?  $default,){
final _that = this;
switch (_that) {
case _StaticExpenseCollection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  List<StaticExpenseTemplate> templates,  List<StaticExpenseOccurrence> occurrences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaticExpenseCollection() when $default != null:
return $default(_that.year,_that.month,_that.templates,_that.occurrences);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  List<StaticExpenseTemplate> templates,  List<StaticExpenseOccurrence> occurrences)  $default,) {final _that = this;
switch (_that) {
case _StaticExpenseCollection():
return $default(_that.year,_that.month,_that.templates,_that.occurrences);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  List<StaticExpenseTemplate> templates,  List<StaticExpenseOccurrence> occurrences)?  $default,) {final _that = this;
switch (_that) {
case _StaticExpenseCollection() when $default != null:
return $default(_that.year,_that.month,_that.templates,_that.occurrences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaticExpenseCollection implements StaticExpenseCollection {
  const _StaticExpenseCollection({required this.year, required this.month, required final  List<StaticExpenseTemplate> templates, required final  List<StaticExpenseOccurrence> occurrences}): _templates = templates,_occurrences = occurrences;
  factory _StaticExpenseCollection.fromJson(Map<String, dynamic> json) => _$StaticExpenseCollectionFromJson(json);

@override final  int year;
@override final  int month;
 final  List<StaticExpenseTemplate> _templates;
@override List<StaticExpenseTemplate> get templates {
  if (_templates is EqualUnmodifiableListView) return _templates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_templates);
}

 final  List<StaticExpenseOccurrence> _occurrences;
@override List<StaticExpenseOccurrence> get occurrences {
  if (_occurrences is EqualUnmodifiableListView) return _occurrences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_occurrences);
}


/// Create a copy of StaticExpenseCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaticExpenseCollectionCopyWith<_StaticExpenseCollection> get copyWith => __$StaticExpenseCollectionCopyWithImpl<_StaticExpenseCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaticExpenseCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaticExpenseCollection&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other._templates, _templates)&&const DeepCollectionEquality().equals(other._occurrences, _occurrences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(_templates),const DeepCollectionEquality().hash(_occurrences));

@override
String toString() {
  return 'StaticExpenseCollection(year: $year, month: $month, templates: $templates, occurrences: $occurrences)';
}


}

/// @nodoc
abstract mixin class _$StaticExpenseCollectionCopyWith<$Res> implements $StaticExpenseCollectionCopyWith<$Res> {
  factory _$StaticExpenseCollectionCopyWith(_StaticExpenseCollection value, $Res Function(_StaticExpenseCollection) _then) = __$StaticExpenseCollectionCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, List<StaticExpenseTemplate> templates, List<StaticExpenseOccurrence> occurrences
});




}
/// @nodoc
class __$StaticExpenseCollectionCopyWithImpl<$Res>
    implements _$StaticExpenseCollectionCopyWith<$Res> {
  __$StaticExpenseCollectionCopyWithImpl(this._self, this._then);

  final _StaticExpenseCollection _self;
  final $Res Function(_StaticExpenseCollection) _then;

/// Create a copy of StaticExpenseCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? templates = null,Object? occurrences = null,}) {
  return _then(_StaticExpenseCollection(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,templates: null == templates ? _self._templates : templates // ignore: cast_nullable_to_non_nullable
as List<StaticExpenseTemplate>,occurrences: null == occurrences ? _self._occurrences : occurrences // ignore: cast_nullable_to_non_nullable
as List<StaticExpenseOccurrence>,
  ));
}


}


/// @nodoc
mixin _$DashboardBalance {

 String get currencyCode; String get accountId; String get accountName; String get walletId; String get walletName; String get walletTypeCode;@DecimalConverter() Decimal get currentBalance;
/// Create a copy of DashboardBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardBalanceCopyWith<DashboardBalance> get copyWith => _$DashboardBalanceCopyWithImpl<DashboardBalance>(this as DashboardBalance, _$identity);

  /// Serializes this DashboardBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardBalance&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.walletTypeCode, walletTypeCode) || other.walletTypeCode == walletTypeCode)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyCode,accountId,accountName,walletId,walletName,walletTypeCode,currentBalance);

@override
String toString() {
  return 'DashboardBalance(currencyCode: $currencyCode, accountId: $accountId, accountName: $accountName, walletId: $walletId, walletName: $walletName, walletTypeCode: $walletTypeCode, currentBalance: $currentBalance)';
}


}

/// @nodoc
abstract mixin class $DashboardBalanceCopyWith<$Res>  {
  factory $DashboardBalanceCopyWith(DashboardBalance value, $Res Function(DashboardBalance) _then) = _$DashboardBalanceCopyWithImpl;
@useResult
$Res call({
 String currencyCode, String accountId, String accountName, String walletId, String walletName, String walletTypeCode,@DecimalConverter() Decimal currentBalance
});




}
/// @nodoc
class _$DashboardBalanceCopyWithImpl<$Res>
    implements $DashboardBalanceCopyWith<$Res> {
  _$DashboardBalanceCopyWithImpl(this._self, this._then);

  final DashboardBalance _self;
  final $Res Function(DashboardBalance) _then;

/// Create a copy of DashboardBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currencyCode = null,Object? accountId = null,Object? accountName = null,Object? walletId = null,Object? walletName = null,Object? walletTypeCode = null,Object? currentBalance = null,}) {
  return _then(_self.copyWith(
currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,walletName: null == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String,walletTypeCode: null == walletTypeCode ? _self.walletTypeCode : walletTypeCode // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardBalance].
extension DashboardBalancePatterns on DashboardBalance {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardBalance() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardBalance value)  $default,){
final _that = this;
switch (_that) {
case _DashboardBalance():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardBalance value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardBalance() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currencyCode,  String accountId,  String accountName,  String walletId,  String walletName,  String walletTypeCode, @DecimalConverter()  Decimal currentBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardBalance() when $default != null:
return $default(_that.currencyCode,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.walletTypeCode,_that.currentBalance);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currencyCode,  String accountId,  String accountName,  String walletId,  String walletName,  String walletTypeCode, @DecimalConverter()  Decimal currentBalance)  $default,) {final _that = this;
switch (_that) {
case _DashboardBalance():
return $default(_that.currencyCode,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.walletTypeCode,_that.currentBalance);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currencyCode,  String accountId,  String accountName,  String walletId,  String walletName,  String walletTypeCode, @DecimalConverter()  Decimal currentBalance)?  $default,) {final _that = this;
switch (_that) {
case _DashboardBalance() when $default != null:
return $default(_that.currencyCode,_that.accountId,_that.accountName,_that.walletId,_that.walletName,_that.walletTypeCode,_that.currentBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardBalance implements DashboardBalance {
  const _DashboardBalance({required this.currencyCode, required this.accountId, required this.accountName, required this.walletId, required this.walletName, required this.walletTypeCode, @DecimalConverter() required this.currentBalance});
  factory _DashboardBalance.fromJson(Map<String, dynamic> json) => _$DashboardBalanceFromJson(json);

@override final  String currencyCode;
@override final  String accountId;
@override final  String accountName;
@override final  String walletId;
@override final  String walletName;
@override final  String walletTypeCode;
@override@DecimalConverter() final  Decimal currentBalance;

/// Create a copy of DashboardBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardBalanceCopyWith<_DashboardBalance> get copyWith => __$DashboardBalanceCopyWithImpl<_DashboardBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardBalance&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletName, walletName) || other.walletName == walletName)&&(identical(other.walletTypeCode, walletTypeCode) || other.walletTypeCode == walletTypeCode)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyCode,accountId,accountName,walletId,walletName,walletTypeCode,currentBalance);

@override
String toString() {
  return 'DashboardBalance(currencyCode: $currencyCode, accountId: $accountId, accountName: $accountName, walletId: $walletId, walletName: $walletName, walletTypeCode: $walletTypeCode, currentBalance: $currentBalance)';
}


}

/// @nodoc
abstract mixin class _$DashboardBalanceCopyWith<$Res> implements $DashboardBalanceCopyWith<$Res> {
  factory _$DashboardBalanceCopyWith(_DashboardBalance value, $Res Function(_DashboardBalance) _then) = __$DashboardBalanceCopyWithImpl;
@override @useResult
$Res call({
 String currencyCode, String accountId, String accountName, String walletId, String walletName, String walletTypeCode,@DecimalConverter() Decimal currentBalance
});




}
/// @nodoc
class __$DashboardBalanceCopyWithImpl<$Res>
    implements _$DashboardBalanceCopyWith<$Res> {
  __$DashboardBalanceCopyWithImpl(this._self, this._then);

  final _DashboardBalance _self;
  final $Res Function(_DashboardBalance) _then;

/// Create a copy of DashboardBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currencyCode = null,Object? accountId = null,Object? accountName = null,Object? walletId = null,Object? walletName = null,Object? walletTypeCode = null,Object? currentBalance = null,}) {
  return _then(_DashboardBalance(
currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,walletName: null == walletName ? _self.walletName : walletName // ignore: cast_nullable_to_non_nullable
as String,walletTypeCode: null == walletTypeCode ? _self.walletTypeCode : walletTypeCode // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}


/// @nodoc
mixin _$DashboardSummary {

 String get currencyCode;@DecimalConverter() Decimal get mainIncome;@DecimalConverter() Decimal get additionalIncome;@DecimalConverter() Decimal get totalIncome;@DecimalConverter() Decimal get staticSpending;@DecimalConverter() Decimal get dynamicSpending;@DecimalConverter() Decimal get totalSpending;@DecimalConverter() Decimal get remainingMoney;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.mainIncome, mainIncome) || other.mainIncome == mainIncome)&&(identical(other.additionalIncome, additionalIncome) || other.additionalIncome == additionalIncome)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.staticSpending, staticSpending) || other.staticSpending == staticSpending)&&(identical(other.dynamicSpending, dynamicSpending) || other.dynamicSpending == dynamicSpending)&&(identical(other.totalSpending, totalSpending) || other.totalSpending == totalSpending)&&(identical(other.remainingMoney, remainingMoney) || other.remainingMoney == remainingMoney));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyCode,mainIncome,additionalIncome,totalIncome,staticSpending,dynamicSpending,totalSpending,remainingMoney);

@override
String toString() {
  return 'DashboardSummary(currencyCode: $currencyCode, mainIncome: $mainIncome, additionalIncome: $additionalIncome, totalIncome: $totalIncome, staticSpending: $staticSpending, dynamicSpending: $dynamicSpending, totalSpending: $totalSpending, remainingMoney: $remainingMoney)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 String currencyCode,@DecimalConverter() Decimal mainIncome,@DecimalConverter() Decimal additionalIncome,@DecimalConverter() Decimal totalIncome,@DecimalConverter() Decimal staticSpending,@DecimalConverter() Decimal dynamicSpending,@DecimalConverter() Decimal totalSpending,@DecimalConverter() Decimal remainingMoney
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currencyCode = null,Object? mainIncome = null,Object? additionalIncome = null,Object? totalIncome = null,Object? staticSpending = null,Object? dynamicSpending = null,Object? totalSpending = null,Object? remainingMoney = null,}) {
  return _then(_self.copyWith(
currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,mainIncome: null == mainIncome ? _self.mainIncome : mainIncome // ignore: cast_nullable_to_non_nullable
as Decimal,additionalIncome: null == additionalIncome ? _self.additionalIncome : additionalIncome // ignore: cast_nullable_to_non_nullable
as Decimal,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as Decimal,staticSpending: null == staticSpending ? _self.staticSpending : staticSpending // ignore: cast_nullable_to_non_nullable
as Decimal,dynamicSpending: null == dynamicSpending ? _self.dynamicSpending : dynamicSpending // ignore: cast_nullable_to_non_nullable
as Decimal,totalSpending: null == totalSpending ? _self.totalSpending : totalSpending // ignore: cast_nullable_to_non_nullable
as Decimal,remainingMoney: null == remainingMoney ? _self.remainingMoney : remainingMoney // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currencyCode, @DecimalConverter()  Decimal mainIncome, @DecimalConverter()  Decimal additionalIncome, @DecimalConverter()  Decimal totalIncome, @DecimalConverter()  Decimal staticSpending, @DecimalConverter()  Decimal dynamicSpending, @DecimalConverter()  Decimal totalSpending, @DecimalConverter()  Decimal remainingMoney)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.currencyCode,_that.mainIncome,_that.additionalIncome,_that.totalIncome,_that.staticSpending,_that.dynamicSpending,_that.totalSpending,_that.remainingMoney);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currencyCode, @DecimalConverter()  Decimal mainIncome, @DecimalConverter()  Decimal additionalIncome, @DecimalConverter()  Decimal totalIncome, @DecimalConverter()  Decimal staticSpending, @DecimalConverter()  Decimal dynamicSpending, @DecimalConverter()  Decimal totalSpending, @DecimalConverter()  Decimal remainingMoney)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.currencyCode,_that.mainIncome,_that.additionalIncome,_that.totalIncome,_that.staticSpending,_that.dynamicSpending,_that.totalSpending,_that.remainingMoney);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currencyCode, @DecimalConverter()  Decimal mainIncome, @DecimalConverter()  Decimal additionalIncome, @DecimalConverter()  Decimal totalIncome, @DecimalConverter()  Decimal staticSpending, @DecimalConverter()  Decimal dynamicSpending, @DecimalConverter()  Decimal totalSpending, @DecimalConverter()  Decimal remainingMoney)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.currencyCode,_that.mainIncome,_that.additionalIncome,_that.totalIncome,_that.staticSpending,_that.dynamicSpending,_that.totalSpending,_that.remainingMoney);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.currencyCode, @DecimalConverter() required this.mainIncome, @DecimalConverter() required this.additionalIncome, @DecimalConverter() required this.totalIncome, @DecimalConverter() required this.staticSpending, @DecimalConverter() required this.dynamicSpending, @DecimalConverter() required this.totalSpending, @DecimalConverter() required this.remainingMoney});
  factory _DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);

@override final  String currencyCode;
@override@DecimalConverter() final  Decimal mainIncome;
@override@DecimalConverter() final  Decimal additionalIncome;
@override@DecimalConverter() final  Decimal totalIncome;
@override@DecimalConverter() final  Decimal staticSpending;
@override@DecimalConverter() final  Decimal dynamicSpending;
@override@DecimalConverter() final  Decimal totalSpending;
@override@DecimalConverter() final  Decimal remainingMoney;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.mainIncome, mainIncome) || other.mainIncome == mainIncome)&&(identical(other.additionalIncome, additionalIncome) || other.additionalIncome == additionalIncome)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.staticSpending, staticSpending) || other.staticSpending == staticSpending)&&(identical(other.dynamicSpending, dynamicSpending) || other.dynamicSpending == dynamicSpending)&&(identical(other.totalSpending, totalSpending) || other.totalSpending == totalSpending)&&(identical(other.remainingMoney, remainingMoney) || other.remainingMoney == remainingMoney));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyCode,mainIncome,additionalIncome,totalIncome,staticSpending,dynamicSpending,totalSpending,remainingMoney);

@override
String toString() {
  return 'DashboardSummary(currencyCode: $currencyCode, mainIncome: $mainIncome, additionalIncome: $additionalIncome, totalIncome: $totalIncome, staticSpending: $staticSpending, dynamicSpending: $dynamicSpending, totalSpending: $totalSpending, remainingMoney: $remainingMoney)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 String currencyCode,@DecimalConverter() Decimal mainIncome,@DecimalConverter() Decimal additionalIncome,@DecimalConverter() Decimal totalIncome,@DecimalConverter() Decimal staticSpending,@DecimalConverter() Decimal dynamicSpending,@DecimalConverter() Decimal totalSpending,@DecimalConverter() Decimal remainingMoney
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currencyCode = null,Object? mainIncome = null,Object? additionalIncome = null,Object? totalIncome = null,Object? staticSpending = null,Object? dynamicSpending = null,Object? totalSpending = null,Object? remainingMoney = null,}) {
  return _then(_DashboardSummary(
currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,mainIncome: null == mainIncome ? _self.mainIncome : mainIncome // ignore: cast_nullable_to_non_nullable
as Decimal,additionalIncome: null == additionalIncome ? _self.additionalIncome : additionalIncome // ignore: cast_nullable_to_non_nullable
as Decimal,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as Decimal,staticSpending: null == staticSpending ? _self.staticSpending : staticSpending // ignore: cast_nullable_to_non_nullable
as Decimal,dynamicSpending: null == dynamicSpending ? _self.dynamicSpending : dynamicSpending // ignore: cast_nullable_to_non_nullable
as Decimal,totalSpending: null == totalSpending ? _self.totalSpending : totalSpending // ignore: cast_nullable_to_non_nullable
as Decimal,remainingMoney: null == remainingMoney ? _self.remainingMoney : remainingMoney // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}


/// @nodoc
mixin _$AllowanceSummary {

 String get currencyCode;@DecimalConverter() Decimal get monthlyAllowance;@DecimalConverter() Decimal get allowanceUsed;@DecimalConverter() Decimal get allowanceRemaining;@DecimalConverter() Decimal get dailyAllowance;@DecimalConverter() Decimal get spentToday;@DecimalConverter() Decimal get remainingToday; int get remainingDays; String? get planId;
/// Create a copy of AllowanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllowanceSummaryCopyWith<AllowanceSummary> get copyWith => _$AllowanceSummaryCopyWithImpl<AllowanceSummary>(this as AllowanceSummary, _$identity);

  /// Serializes this AllowanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllowanceSummary&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.monthlyAllowance, monthlyAllowance) || other.monthlyAllowance == monthlyAllowance)&&(identical(other.allowanceUsed, allowanceUsed) || other.allowanceUsed == allowanceUsed)&&(identical(other.allowanceRemaining, allowanceRemaining) || other.allowanceRemaining == allowanceRemaining)&&(identical(other.dailyAllowance, dailyAllowance) || other.dailyAllowance == dailyAllowance)&&(identical(other.spentToday, spentToday) || other.spentToday == spentToday)&&(identical(other.remainingToday, remainingToday) || other.remainingToday == remainingToday)&&(identical(other.remainingDays, remainingDays) || other.remainingDays == remainingDays)&&(identical(other.planId, planId) || other.planId == planId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyCode,monthlyAllowance,allowanceUsed,allowanceRemaining,dailyAllowance,spentToday,remainingToday,remainingDays,planId);

@override
String toString() {
  return 'AllowanceSummary(currencyCode: $currencyCode, monthlyAllowance: $monthlyAllowance, allowanceUsed: $allowanceUsed, allowanceRemaining: $allowanceRemaining, dailyAllowance: $dailyAllowance, spentToday: $spentToday, remainingToday: $remainingToday, remainingDays: $remainingDays, planId: $planId)';
}


}

/// @nodoc
abstract mixin class $AllowanceSummaryCopyWith<$Res>  {
  factory $AllowanceSummaryCopyWith(AllowanceSummary value, $Res Function(AllowanceSummary) _then) = _$AllowanceSummaryCopyWithImpl;
@useResult
$Res call({
 String currencyCode,@DecimalConverter() Decimal monthlyAllowance,@DecimalConverter() Decimal allowanceUsed,@DecimalConverter() Decimal allowanceRemaining,@DecimalConverter() Decimal dailyAllowance,@DecimalConverter() Decimal spentToday,@DecimalConverter() Decimal remainingToday, int remainingDays, String? planId
});




}
/// @nodoc
class _$AllowanceSummaryCopyWithImpl<$Res>
    implements $AllowanceSummaryCopyWith<$Res> {
  _$AllowanceSummaryCopyWithImpl(this._self, this._then);

  final AllowanceSummary _self;
  final $Res Function(AllowanceSummary) _then;

/// Create a copy of AllowanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currencyCode = null,Object? monthlyAllowance = null,Object? allowanceUsed = null,Object? allowanceRemaining = null,Object? dailyAllowance = null,Object? spentToday = null,Object? remainingToday = null,Object? remainingDays = null,Object? planId = freezed,}) {
  return _then(_self.copyWith(
currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,monthlyAllowance: null == monthlyAllowance ? _self.monthlyAllowance : monthlyAllowance // ignore: cast_nullable_to_non_nullable
as Decimal,allowanceUsed: null == allowanceUsed ? _self.allowanceUsed : allowanceUsed // ignore: cast_nullable_to_non_nullable
as Decimal,allowanceRemaining: null == allowanceRemaining ? _self.allowanceRemaining : allowanceRemaining // ignore: cast_nullable_to_non_nullable
as Decimal,dailyAllowance: null == dailyAllowance ? _self.dailyAllowance : dailyAllowance // ignore: cast_nullable_to_non_nullable
as Decimal,spentToday: null == spentToday ? _self.spentToday : spentToday // ignore: cast_nullable_to_non_nullable
as Decimal,remainingToday: null == remainingToday ? _self.remainingToday : remainingToday // ignore: cast_nullable_to_non_nullable
as Decimal,remainingDays: null == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AllowanceSummary].
extension AllowanceSummaryPatterns on AllowanceSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AllowanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllowanceSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AllowanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _AllowanceSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AllowanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AllowanceSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currencyCode, @DecimalConverter()  Decimal monthlyAllowance, @DecimalConverter()  Decimal allowanceUsed, @DecimalConverter()  Decimal allowanceRemaining, @DecimalConverter()  Decimal dailyAllowance, @DecimalConverter()  Decimal spentToday, @DecimalConverter()  Decimal remainingToday,  int remainingDays,  String? planId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllowanceSummary() when $default != null:
return $default(_that.currencyCode,_that.monthlyAllowance,_that.allowanceUsed,_that.allowanceRemaining,_that.dailyAllowance,_that.spentToday,_that.remainingToday,_that.remainingDays,_that.planId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currencyCode, @DecimalConverter()  Decimal monthlyAllowance, @DecimalConverter()  Decimal allowanceUsed, @DecimalConverter()  Decimal allowanceRemaining, @DecimalConverter()  Decimal dailyAllowance, @DecimalConverter()  Decimal spentToday, @DecimalConverter()  Decimal remainingToday,  int remainingDays,  String? planId)  $default,) {final _that = this;
switch (_that) {
case _AllowanceSummary():
return $default(_that.currencyCode,_that.monthlyAllowance,_that.allowanceUsed,_that.allowanceRemaining,_that.dailyAllowance,_that.spentToday,_that.remainingToday,_that.remainingDays,_that.planId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currencyCode, @DecimalConverter()  Decimal monthlyAllowance, @DecimalConverter()  Decimal allowanceUsed, @DecimalConverter()  Decimal allowanceRemaining, @DecimalConverter()  Decimal dailyAllowance, @DecimalConverter()  Decimal spentToday, @DecimalConverter()  Decimal remainingToday,  int remainingDays,  String? planId)?  $default,) {final _that = this;
switch (_that) {
case _AllowanceSummary() when $default != null:
return $default(_that.currencyCode,_that.monthlyAllowance,_that.allowanceUsed,_that.allowanceRemaining,_that.dailyAllowance,_that.spentToday,_that.remainingToday,_that.remainingDays,_that.planId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AllowanceSummary implements AllowanceSummary {
  const _AllowanceSummary({required this.currencyCode, @DecimalConverter() required this.monthlyAllowance, @DecimalConverter() required this.allowanceUsed, @DecimalConverter() required this.allowanceRemaining, @DecimalConverter() required this.dailyAllowance, @DecimalConverter() required this.spentToday, @DecimalConverter() required this.remainingToday, required this.remainingDays, this.planId});
  factory _AllowanceSummary.fromJson(Map<String, dynamic> json) => _$AllowanceSummaryFromJson(json);

@override final  String currencyCode;
@override@DecimalConverter() final  Decimal monthlyAllowance;
@override@DecimalConverter() final  Decimal allowanceUsed;
@override@DecimalConverter() final  Decimal allowanceRemaining;
@override@DecimalConverter() final  Decimal dailyAllowance;
@override@DecimalConverter() final  Decimal spentToday;
@override@DecimalConverter() final  Decimal remainingToday;
@override final  int remainingDays;
@override final  String? planId;

/// Create a copy of AllowanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllowanceSummaryCopyWith<_AllowanceSummary> get copyWith => __$AllowanceSummaryCopyWithImpl<_AllowanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AllowanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllowanceSummary&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.monthlyAllowance, monthlyAllowance) || other.monthlyAllowance == monthlyAllowance)&&(identical(other.allowanceUsed, allowanceUsed) || other.allowanceUsed == allowanceUsed)&&(identical(other.allowanceRemaining, allowanceRemaining) || other.allowanceRemaining == allowanceRemaining)&&(identical(other.dailyAllowance, dailyAllowance) || other.dailyAllowance == dailyAllowance)&&(identical(other.spentToday, spentToday) || other.spentToday == spentToday)&&(identical(other.remainingToday, remainingToday) || other.remainingToday == remainingToday)&&(identical(other.remainingDays, remainingDays) || other.remainingDays == remainingDays)&&(identical(other.planId, planId) || other.planId == planId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyCode,monthlyAllowance,allowanceUsed,allowanceRemaining,dailyAllowance,spentToday,remainingToday,remainingDays,planId);

@override
String toString() {
  return 'AllowanceSummary(currencyCode: $currencyCode, monthlyAllowance: $monthlyAllowance, allowanceUsed: $allowanceUsed, allowanceRemaining: $allowanceRemaining, dailyAllowance: $dailyAllowance, spentToday: $spentToday, remainingToday: $remainingToday, remainingDays: $remainingDays, planId: $planId)';
}


}

/// @nodoc
abstract mixin class _$AllowanceSummaryCopyWith<$Res> implements $AllowanceSummaryCopyWith<$Res> {
  factory _$AllowanceSummaryCopyWith(_AllowanceSummary value, $Res Function(_AllowanceSummary) _then) = __$AllowanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String currencyCode,@DecimalConverter() Decimal monthlyAllowance,@DecimalConverter() Decimal allowanceUsed,@DecimalConverter() Decimal allowanceRemaining,@DecimalConverter() Decimal dailyAllowance,@DecimalConverter() Decimal spentToday,@DecimalConverter() Decimal remainingToday, int remainingDays, String? planId
});




}
/// @nodoc
class __$AllowanceSummaryCopyWithImpl<$Res>
    implements _$AllowanceSummaryCopyWith<$Res> {
  __$AllowanceSummaryCopyWithImpl(this._self, this._then);

  final _AllowanceSummary _self;
  final $Res Function(_AllowanceSummary) _then;

/// Create a copy of AllowanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currencyCode = null,Object? monthlyAllowance = null,Object? allowanceUsed = null,Object? allowanceRemaining = null,Object? dailyAllowance = null,Object? spentToday = null,Object? remainingToday = null,Object? remainingDays = null,Object? planId = freezed,}) {
  return _then(_AllowanceSummary(
currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,monthlyAllowance: null == monthlyAllowance ? _self.monthlyAllowance : monthlyAllowance // ignore: cast_nullable_to_non_nullable
as Decimal,allowanceUsed: null == allowanceUsed ? _self.allowanceUsed : allowanceUsed // ignore: cast_nullable_to_non_nullable
as Decimal,allowanceRemaining: null == allowanceRemaining ? _self.allowanceRemaining : allowanceRemaining // ignore: cast_nullable_to_non_nullable
as Decimal,dailyAllowance: null == dailyAllowance ? _self.dailyAllowance : dailyAllowance // ignore: cast_nullable_to_non_nullable
as Decimal,spentToday: null == spentToday ? _self.spentToday : spentToday // ignore: cast_nullable_to_non_nullable
as Decimal,remainingToday: null == remainingToday ? _self.remainingToday : remainingToday // ignore: cast_nullable_to_non_nullable
as Decimal,remainingDays: null == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DashboardPeriod {

 int get year; int get month; String get timezone; String get accountId; String? get currencyCode;
/// Create a copy of DashboardPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPeriodCopyWith<DashboardPeriod> get copyWith => _$DashboardPeriodCopyWithImpl<DashboardPeriod>(this as DashboardPeriod, _$identity);

  /// Serializes this DashboardPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPeriod&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,timezone,accountId,currencyCode);

@override
String toString() {
  return 'DashboardPeriod(year: $year, month: $month, timezone: $timezone, accountId: $accountId, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class $DashboardPeriodCopyWith<$Res>  {
  factory $DashboardPeriodCopyWith(DashboardPeriod value, $Res Function(DashboardPeriod) _then) = _$DashboardPeriodCopyWithImpl;
@useResult
$Res call({
 int year, int month, String timezone, String accountId, String? currencyCode
});




}
/// @nodoc
class _$DashboardPeriodCopyWithImpl<$Res>
    implements $DashboardPeriodCopyWith<$Res> {
  _$DashboardPeriodCopyWithImpl(this._self, this._then);

  final DashboardPeriod _self;
  final $Res Function(DashboardPeriod) _then;

/// Create a copy of DashboardPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? timezone = null,Object? accountId = null,Object? currencyCode = freezed,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPeriod].
extension DashboardPeriodPatterns on DashboardPeriod {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPeriod() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPeriod value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPeriod():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPeriod() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  String timezone,  String accountId,  String? currencyCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPeriod() when $default != null:
return $default(_that.year,_that.month,_that.timezone,_that.accountId,_that.currencyCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  String timezone,  String accountId,  String? currencyCode)  $default,) {final _that = this;
switch (_that) {
case _DashboardPeriod():
return $default(_that.year,_that.month,_that.timezone,_that.accountId,_that.currencyCode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  String timezone,  String accountId,  String? currencyCode)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPeriod() when $default != null:
return $default(_that.year,_that.month,_that.timezone,_that.accountId,_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPeriod implements DashboardPeriod {
  const _DashboardPeriod({required this.year, required this.month, required this.timezone, required this.accountId, this.currencyCode});
  factory _DashboardPeriod.fromJson(Map<String, dynamic> json) => _$DashboardPeriodFromJson(json);

@override final  int year;
@override final  int month;
@override final  String timezone;
@override final  String accountId;
@override final  String? currencyCode;

/// Create a copy of DashboardPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPeriodCopyWith<_DashboardPeriod> get copyWith => __$DashboardPeriodCopyWithImpl<_DashboardPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPeriod&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,timezone,accountId,currencyCode);

@override
String toString() {
  return 'DashboardPeriod(year: $year, month: $month, timezone: $timezone, accountId: $accountId, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$DashboardPeriodCopyWith<$Res> implements $DashboardPeriodCopyWith<$Res> {
  factory _$DashboardPeriodCopyWith(_DashboardPeriod value, $Res Function(_DashboardPeriod) _then) = __$DashboardPeriodCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, String timezone, String accountId, String? currencyCode
});




}
/// @nodoc
class __$DashboardPeriodCopyWithImpl<$Res>
    implements _$DashboardPeriodCopyWith<$Res> {
  __$DashboardPeriodCopyWithImpl(this._self, this._then);

  final _DashboardPeriod _self;
  final $Res Function(_DashboardPeriod) _then;

/// Create a copy of DashboardPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? timezone = null,Object? accountId = null,Object? currencyCode = freezed,}) {
  return _then(_DashboardPeriod(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Dashboard {

 User get user; DashboardPeriod get period; List<DashboardBalance> get balances; List<DashboardSummary> get summaryByCurrency; List<AllowanceSummary> get allowanceByCurrency; List<StaticExpenseOccurrence> get staticExpenses; List<TransactionItem> get recentTransactions;
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCopyWith<Dashboard> get copyWith => _$DashboardCopyWithImpl<Dashboard>(this as Dashboard, _$identity);

  /// Serializes this Dashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dashboard&&(identical(other.user, user) || other.user == user)&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other.balances, balances)&&const DeepCollectionEquality().equals(other.summaryByCurrency, summaryByCurrency)&&const DeepCollectionEquality().equals(other.allowanceByCurrency, allowanceByCurrency)&&const DeepCollectionEquality().equals(other.staticExpenses, staticExpenses)&&const DeepCollectionEquality().equals(other.recentTransactions, recentTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,period,const DeepCollectionEquality().hash(balances),const DeepCollectionEquality().hash(summaryByCurrency),const DeepCollectionEquality().hash(allowanceByCurrency),const DeepCollectionEquality().hash(staticExpenses),const DeepCollectionEquality().hash(recentTransactions));

@override
String toString() {
  return 'Dashboard(user: $user, period: $period, balances: $balances, summaryByCurrency: $summaryByCurrency, allowanceByCurrency: $allowanceByCurrency, staticExpenses: $staticExpenses, recentTransactions: $recentTransactions)';
}


}

/// @nodoc
abstract mixin class $DashboardCopyWith<$Res>  {
  factory $DashboardCopyWith(Dashboard value, $Res Function(Dashboard) _then) = _$DashboardCopyWithImpl;
@useResult
$Res call({
 User user, DashboardPeriod period, List<DashboardBalance> balances, List<DashboardSummary> summaryByCurrency, List<AllowanceSummary> allowanceByCurrency, List<StaticExpenseOccurrence> staticExpenses, List<TransactionItem> recentTransactions
});


$UserCopyWith<$Res> get user;$DashboardPeriodCopyWith<$Res> get period;

}
/// @nodoc
class _$DashboardCopyWithImpl<$Res>
    implements $DashboardCopyWith<$Res> {
  _$DashboardCopyWithImpl(this._self, this._then);

  final Dashboard _self;
  final $Res Function(Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? period = null,Object? balances = null,Object? summaryByCurrency = null,Object? allowanceByCurrency = null,Object? staticExpenses = null,Object? recentTransactions = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DashboardPeriod,balances: null == balances ? _self.balances : balances // ignore: cast_nullable_to_non_nullable
as List<DashboardBalance>,summaryByCurrency: null == summaryByCurrency ? _self.summaryByCurrency : summaryByCurrency // ignore: cast_nullable_to_non_nullable
as List<DashboardSummary>,allowanceByCurrency: null == allowanceByCurrency ? _self.allowanceByCurrency : allowanceByCurrency // ignore: cast_nullable_to_non_nullable
as List<AllowanceSummary>,staticExpenses: null == staticExpenses ? _self.staticExpenses : staticExpenses // ignore: cast_nullable_to_non_nullable
as List<StaticExpenseOccurrence>,recentTransactions: null == recentTransactions ? _self.recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,
  ));
}
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPeriodCopyWith<$Res> get period {
  
  return $DashboardPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}
}


/// Adds pattern-matching-related methods to [Dashboard].
extension DashboardPatterns on Dashboard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dashboard value)  $default,){
final _that = this;
switch (_that) {
case _Dashboard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dashboard value)?  $default,){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User user,  DashboardPeriod period,  List<DashboardBalance> balances,  List<DashboardSummary> summaryByCurrency,  List<AllowanceSummary> allowanceByCurrency,  List<StaticExpenseOccurrence> staticExpenses,  List<TransactionItem> recentTransactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.user,_that.period,_that.balances,_that.summaryByCurrency,_that.allowanceByCurrency,_that.staticExpenses,_that.recentTransactions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User user,  DashboardPeriod period,  List<DashboardBalance> balances,  List<DashboardSummary> summaryByCurrency,  List<AllowanceSummary> allowanceByCurrency,  List<StaticExpenseOccurrence> staticExpenses,  List<TransactionItem> recentTransactions)  $default,) {final _that = this;
switch (_that) {
case _Dashboard():
return $default(_that.user,_that.period,_that.balances,_that.summaryByCurrency,_that.allowanceByCurrency,_that.staticExpenses,_that.recentTransactions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User user,  DashboardPeriod period,  List<DashboardBalance> balances,  List<DashboardSummary> summaryByCurrency,  List<AllowanceSummary> allowanceByCurrency,  List<StaticExpenseOccurrence> staticExpenses,  List<TransactionItem> recentTransactions)?  $default,) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.user,_that.period,_that.balances,_that.summaryByCurrency,_that.allowanceByCurrency,_that.staticExpenses,_that.recentTransactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dashboard implements Dashboard {
  const _Dashboard({required this.user, required this.period, required final  List<DashboardBalance> balances, required final  List<DashboardSummary> summaryByCurrency, required final  List<AllowanceSummary> allowanceByCurrency, required final  List<StaticExpenseOccurrence> staticExpenses, required final  List<TransactionItem> recentTransactions}): _balances = balances,_summaryByCurrency = summaryByCurrency,_allowanceByCurrency = allowanceByCurrency,_staticExpenses = staticExpenses,_recentTransactions = recentTransactions;
  factory _Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);

@override final  User user;
@override final  DashboardPeriod period;
 final  List<DashboardBalance> _balances;
@override List<DashboardBalance> get balances {
  if (_balances is EqualUnmodifiableListView) return _balances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_balances);
}

 final  List<DashboardSummary> _summaryByCurrency;
@override List<DashboardSummary> get summaryByCurrency {
  if (_summaryByCurrency is EqualUnmodifiableListView) return _summaryByCurrency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_summaryByCurrency);
}

 final  List<AllowanceSummary> _allowanceByCurrency;
@override List<AllowanceSummary> get allowanceByCurrency {
  if (_allowanceByCurrency is EqualUnmodifiableListView) return _allowanceByCurrency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowanceByCurrency);
}

 final  List<StaticExpenseOccurrence> _staticExpenses;
@override List<StaticExpenseOccurrence> get staticExpenses {
  if (_staticExpenses is EqualUnmodifiableListView) return _staticExpenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staticExpenses);
}

 final  List<TransactionItem> _recentTransactions;
@override List<TransactionItem> get recentTransactions {
  if (_recentTransactions is EqualUnmodifiableListView) return _recentTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentTransactions);
}


/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCopyWith<_Dashboard> get copyWith => __$DashboardCopyWithImpl<_Dashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dashboard&&(identical(other.user, user) || other.user == user)&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other._balances, _balances)&&const DeepCollectionEquality().equals(other._summaryByCurrency, _summaryByCurrency)&&const DeepCollectionEquality().equals(other._allowanceByCurrency, _allowanceByCurrency)&&const DeepCollectionEquality().equals(other._staticExpenses, _staticExpenses)&&const DeepCollectionEquality().equals(other._recentTransactions, _recentTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,period,const DeepCollectionEquality().hash(_balances),const DeepCollectionEquality().hash(_summaryByCurrency),const DeepCollectionEquality().hash(_allowanceByCurrency),const DeepCollectionEquality().hash(_staticExpenses),const DeepCollectionEquality().hash(_recentTransactions));

@override
String toString() {
  return 'Dashboard(user: $user, period: $period, balances: $balances, summaryByCurrency: $summaryByCurrency, allowanceByCurrency: $allowanceByCurrency, staticExpenses: $staticExpenses, recentTransactions: $recentTransactions)';
}


}

/// @nodoc
abstract mixin class _$DashboardCopyWith<$Res> implements $DashboardCopyWith<$Res> {
  factory _$DashboardCopyWith(_Dashboard value, $Res Function(_Dashboard) _then) = __$DashboardCopyWithImpl;
@override @useResult
$Res call({
 User user, DashboardPeriod period, List<DashboardBalance> balances, List<DashboardSummary> summaryByCurrency, List<AllowanceSummary> allowanceByCurrency, List<StaticExpenseOccurrence> staticExpenses, List<TransactionItem> recentTransactions
});


@override $UserCopyWith<$Res> get user;@override $DashboardPeriodCopyWith<$Res> get period;

}
/// @nodoc
class __$DashboardCopyWithImpl<$Res>
    implements _$DashboardCopyWith<$Res> {
  __$DashboardCopyWithImpl(this._self, this._then);

  final _Dashboard _self;
  final $Res Function(_Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? period = null,Object? balances = null,Object? summaryByCurrency = null,Object? allowanceByCurrency = null,Object? staticExpenses = null,Object? recentTransactions = null,}) {
  return _then(_Dashboard(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DashboardPeriod,balances: null == balances ? _self._balances : balances // ignore: cast_nullable_to_non_nullable
as List<DashboardBalance>,summaryByCurrency: null == summaryByCurrency ? _self._summaryByCurrency : summaryByCurrency // ignore: cast_nullable_to_non_nullable
as List<DashboardSummary>,allowanceByCurrency: null == allowanceByCurrency ? _self._allowanceByCurrency : allowanceByCurrency // ignore: cast_nullable_to_non_nullable
as List<AllowanceSummary>,staticExpenses: null == staticExpenses ? _self._staticExpenses : staticExpenses // ignore: cast_nullable_to_non_nullable
as List<StaticExpenseOccurrence>,recentTransactions: null == recentTransactions ? _self._recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,
  ));
}

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPeriodCopyWith<$Res> get period {
  
  return $DashboardPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}
}


/// @nodoc
mixin _$Transfer {

 String get id; String get fromWalletId; String get fromWalletName; String get toWalletId; String get toWalletName;@DecimalConverter() Decimal get amount; String get currencyCode; String? get notes; String get transferDate; String get status;
/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferCopyWith<Transfer> get copyWith => _$TransferCopyWithImpl<Transfer>(this as Transfer, _$identity);

  /// Serializes this Transfer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transfer&&(identical(other.id, id) || other.id == id)&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.fromWalletName, fromWalletName) || other.fromWalletName == fromWalletName)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.toWalletName, toWalletName) || other.toWalletName == toWalletName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.transferDate, transferDate) || other.transferDate == transferDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromWalletId,fromWalletName,toWalletId,toWalletName,amount,currencyCode,notes,transferDate,status);

@override
String toString() {
  return 'Transfer(id: $id, fromWalletId: $fromWalletId, fromWalletName: $fromWalletName, toWalletId: $toWalletId, toWalletName: $toWalletName, amount: $amount, currencyCode: $currencyCode, notes: $notes, transferDate: $transferDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $TransferCopyWith<$Res>  {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) _then) = _$TransferCopyWithImpl;
@useResult
$Res call({
 String id, String fromWalletId, String fromWalletName, String toWalletId, String toWalletName,@DecimalConverter() Decimal amount, String currencyCode, String? notes, String transferDate, String status
});




}
/// @nodoc
class _$TransferCopyWithImpl<$Res>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._self, this._then);

  final Transfer _self;
  final $Res Function(Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromWalletId = null,Object? fromWalletName = null,Object? toWalletId = null,Object? toWalletName = null,Object? amount = null,Object? currencyCode = null,Object? notes = freezed,Object? transferDate = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as String,fromWalletName: null == fromWalletName ? _self.fromWalletName : fromWalletName // ignore: cast_nullable_to_non_nullable
as String,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String,toWalletName: null == toWalletName ? _self.toWalletName : toWalletName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,transferDate: null == transferDate ? _self.transferDate : transferDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Transfer].
extension TransferPatterns on Transfer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transfer value)  $default,){
final _that = this;
switch (_that) {
case _Transfer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transfer value)?  $default,){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromWalletId,  String fromWalletName,  String toWalletId,  String toWalletName, @DecimalConverter()  Decimal amount,  String currencyCode,  String? notes,  String transferDate,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.fromWalletId,_that.fromWalletName,_that.toWalletId,_that.toWalletName,_that.amount,_that.currencyCode,_that.notes,_that.transferDate,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromWalletId,  String fromWalletName,  String toWalletId,  String toWalletName, @DecimalConverter()  Decimal amount,  String currencyCode,  String? notes,  String transferDate,  String status)  $default,) {final _that = this;
switch (_that) {
case _Transfer():
return $default(_that.id,_that.fromWalletId,_that.fromWalletName,_that.toWalletId,_that.toWalletName,_that.amount,_that.currencyCode,_that.notes,_that.transferDate,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromWalletId,  String fromWalletName,  String toWalletId,  String toWalletName, @DecimalConverter()  Decimal amount,  String currencyCode,  String? notes,  String transferDate,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.fromWalletId,_that.fromWalletName,_that.toWalletId,_that.toWalletName,_that.amount,_that.currencyCode,_that.notes,_that.transferDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transfer implements Transfer {
  const _Transfer({required this.id, required this.fromWalletId, required this.fromWalletName, required this.toWalletId, required this.toWalletName, @DecimalConverter() required this.amount, required this.currencyCode, this.notes, required this.transferDate, required this.status});
  factory _Transfer.fromJson(Map<String, dynamic> json) => _$TransferFromJson(json);

@override final  String id;
@override final  String fromWalletId;
@override final  String fromWalletName;
@override final  String toWalletId;
@override final  String toWalletName;
@override@DecimalConverter() final  Decimal amount;
@override final  String currencyCode;
@override final  String? notes;
@override final  String transferDate;
@override final  String status;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferCopyWith<_Transfer> get copyWith => __$TransferCopyWithImpl<_Transfer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transfer&&(identical(other.id, id) || other.id == id)&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.fromWalletName, fromWalletName) || other.fromWalletName == fromWalletName)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.toWalletName, toWalletName) || other.toWalletName == toWalletName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.transferDate, transferDate) || other.transferDate == transferDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromWalletId,fromWalletName,toWalletId,toWalletName,amount,currencyCode,notes,transferDate,status);

@override
String toString() {
  return 'Transfer(id: $id, fromWalletId: $fromWalletId, fromWalletName: $fromWalletName, toWalletId: $toWalletId, toWalletName: $toWalletName, amount: $amount, currencyCode: $currencyCode, notes: $notes, transferDate: $transferDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TransferCopyWith<$Res> implements $TransferCopyWith<$Res> {
  factory _$TransferCopyWith(_Transfer value, $Res Function(_Transfer) _then) = __$TransferCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromWalletId, String fromWalletName, String toWalletId, String toWalletName,@DecimalConverter() Decimal amount, String currencyCode, String? notes, String transferDate, String status
});




}
/// @nodoc
class __$TransferCopyWithImpl<$Res>
    implements _$TransferCopyWith<$Res> {
  __$TransferCopyWithImpl(this._self, this._then);

  final _Transfer _self;
  final $Res Function(_Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromWalletId = null,Object? fromWalletName = null,Object? toWalletId = null,Object? toWalletName = null,Object? amount = null,Object? currencyCode = null,Object? notes = freezed,Object? transferDate = null,Object? status = null,}) {
  return _then(_Transfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as String,fromWalletName: null == fromWalletName ? _self.fromWalletName : fromWalletName // ignore: cast_nullable_to_non_nullable
as String,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String,toWalletName: null == toWalletName ? _self.toWalletName : toWalletName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,transferDate: null == transferDate ? _self.transferDate : transferDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TransactionRequest {

 String get transactionType;@DecimalConverter() Decimal get amount; String get walletId; String? get categoryId; String? get description; String? get notes; String get transactionDate; String? get transactionTime;
/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<TransactionRequest> get copyWith => _$TransactionRequestCopyWithImpl<TransactionRequest>(this as TransactionRequest, _$identity);

  /// Serializes this TransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionRequest&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.transactionTime, transactionTime) || other.transactionTime == transactionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionType,amount,walletId,categoryId,description,notes,transactionDate,transactionTime);

@override
String toString() {
  return 'TransactionRequest(transactionType: $transactionType, amount: $amount, walletId: $walletId, categoryId: $categoryId, description: $description, notes: $notes, transactionDate: $transactionDate, transactionTime: $transactionTime)';
}


}

/// @nodoc
abstract mixin class $TransactionRequestCopyWith<$Res>  {
  factory $TransactionRequestCopyWith(TransactionRequest value, $Res Function(TransactionRequest) _then) = _$TransactionRequestCopyWithImpl;
@useResult
$Res call({
 String transactionType,@DecimalConverter() Decimal amount, String walletId, String? categoryId, String? description, String? notes, String transactionDate, String? transactionTime
});




}
/// @nodoc
class _$TransactionRequestCopyWithImpl<$Res>
    implements $TransactionRequestCopyWith<$Res> {
  _$TransactionRequestCopyWithImpl(this._self, this._then);

  final TransactionRequest _self;
  final $Res Function(TransactionRequest) _then;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionType = null,Object? amount = null,Object? walletId = null,Object? categoryId = freezed,Object? description = freezed,Object? notes = freezed,Object? transactionDate = null,Object? transactionTime = freezed,}) {
  return _then(_self.copyWith(
transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String,transactionTime: freezed == transactionTime ? _self.transactionTime : transactionTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionRequest].
extension TransactionRequestPatterns on TransactionRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransactionRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transactionType, @DecimalConverter()  Decimal amount,  String walletId,  String? categoryId,  String? description,  String? notes,  String transactionDate,  String? transactionTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that.transactionType,_that.amount,_that.walletId,_that.categoryId,_that.description,_that.notes,_that.transactionDate,_that.transactionTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transactionType, @DecimalConverter()  Decimal amount,  String walletId,  String? categoryId,  String? description,  String? notes,  String transactionDate,  String? transactionTime)  $default,) {final _that = this;
switch (_that) {
case _TransactionRequest():
return $default(_that.transactionType,_that.amount,_that.walletId,_that.categoryId,_that.description,_that.notes,_that.transactionDate,_that.transactionTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transactionType, @DecimalConverter()  Decimal amount,  String walletId,  String? categoryId,  String? description,  String? notes,  String transactionDate,  String? transactionTime)?  $default,) {final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that.transactionType,_that.amount,_that.walletId,_that.categoryId,_that.description,_that.notes,_that.transactionDate,_that.transactionTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionRequest implements TransactionRequest {
  const _TransactionRequest({required this.transactionType, @DecimalConverter() required this.amount, required this.walletId, this.categoryId, this.description, this.notes, required this.transactionDate, this.transactionTime});
  factory _TransactionRequest.fromJson(Map<String, dynamic> json) => _$TransactionRequestFromJson(json);

@override final  String transactionType;
@override@DecimalConverter() final  Decimal amount;
@override final  String walletId;
@override final  String? categoryId;
@override final  String? description;
@override final  String? notes;
@override final  String transactionDate;
@override final  String? transactionTime;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionRequestCopyWith<_TransactionRequest> get copyWith => __$TransactionRequestCopyWithImpl<_TransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionRequest&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.transactionTime, transactionTime) || other.transactionTime == transactionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionType,amount,walletId,categoryId,description,notes,transactionDate,transactionTime);

@override
String toString() {
  return 'TransactionRequest(transactionType: $transactionType, amount: $amount, walletId: $walletId, categoryId: $categoryId, description: $description, notes: $notes, transactionDate: $transactionDate, transactionTime: $transactionTime)';
}


}

/// @nodoc
abstract mixin class _$TransactionRequestCopyWith<$Res> implements $TransactionRequestCopyWith<$Res> {
  factory _$TransactionRequestCopyWith(_TransactionRequest value, $Res Function(_TransactionRequest) _then) = __$TransactionRequestCopyWithImpl;
@override @useResult
$Res call({
 String transactionType,@DecimalConverter() Decimal amount, String walletId, String? categoryId, String? description, String? notes, String transactionDate, String? transactionTime
});




}
/// @nodoc
class __$TransactionRequestCopyWithImpl<$Res>
    implements _$TransactionRequestCopyWith<$Res> {
  __$TransactionRequestCopyWithImpl(this._self, this._then);

  final _TransactionRequest _self;
  final $Res Function(_TransactionRequest) _then;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionType = null,Object? amount = null,Object? walletId = null,Object? categoryId = freezed,Object? description = freezed,Object? notes = freezed,Object? transactionDate = null,Object? transactionTime = freezed,}) {
  return _then(_TransactionRequest(
transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String,transactionTime: freezed == transactionTime ? _self.transactionTime : transactionTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OccurrencePaymentRequest {

 String? get walletId;@DecimalConverter() Decimal? get amount; String? get paidAt; String? get notes;
/// Create a copy of OccurrencePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OccurrencePaymentRequestCopyWith<OccurrencePaymentRequest> get copyWith => _$OccurrencePaymentRequestCopyWithImpl<OccurrencePaymentRequest>(this as OccurrencePaymentRequest, _$identity);

  /// Serializes this OccurrencePaymentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OccurrencePaymentRequest&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,amount,paidAt,notes);

@override
String toString() {
  return 'OccurrencePaymentRequest(walletId: $walletId, amount: $amount, paidAt: $paidAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $OccurrencePaymentRequestCopyWith<$Res>  {
  factory $OccurrencePaymentRequestCopyWith(OccurrencePaymentRequest value, $Res Function(OccurrencePaymentRequest) _then) = _$OccurrencePaymentRequestCopyWithImpl;
@useResult
$Res call({
 String? walletId,@DecimalConverter() Decimal? amount, String? paidAt, String? notes
});




}
/// @nodoc
class _$OccurrencePaymentRequestCopyWithImpl<$Res>
    implements $OccurrencePaymentRequestCopyWith<$Res> {
  _$OccurrencePaymentRequestCopyWithImpl(this._self, this._then);

  final OccurrencePaymentRequest _self;
  final $Res Function(OccurrencePaymentRequest) _then;

/// Create a copy of OccurrencePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? walletId = freezed,Object? amount = freezed,Object? paidAt = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OccurrencePaymentRequest].
extension OccurrencePaymentRequestPatterns on OccurrencePaymentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OccurrencePaymentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OccurrencePaymentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OccurrencePaymentRequest value)  $default,){
final _that = this;
switch (_that) {
case _OccurrencePaymentRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OccurrencePaymentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OccurrencePaymentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? walletId, @DecimalConverter()  Decimal? amount,  String? paidAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OccurrencePaymentRequest() when $default != null:
return $default(_that.walletId,_that.amount,_that.paidAt,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? walletId, @DecimalConverter()  Decimal? amount,  String? paidAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _OccurrencePaymentRequest():
return $default(_that.walletId,_that.amount,_that.paidAt,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? walletId, @DecimalConverter()  Decimal? amount,  String? paidAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _OccurrencePaymentRequest() when $default != null:
return $default(_that.walletId,_that.amount,_that.paidAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OccurrencePaymentRequest implements OccurrencePaymentRequest {
  const _OccurrencePaymentRequest({this.walletId, @DecimalConverter() this.amount, this.paidAt, this.notes});
  factory _OccurrencePaymentRequest.fromJson(Map<String, dynamic> json) => _$OccurrencePaymentRequestFromJson(json);

@override final  String? walletId;
@override@DecimalConverter() final  Decimal? amount;
@override final  String? paidAt;
@override final  String? notes;

/// Create a copy of OccurrencePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OccurrencePaymentRequestCopyWith<_OccurrencePaymentRequest> get copyWith => __$OccurrencePaymentRequestCopyWithImpl<_OccurrencePaymentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OccurrencePaymentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OccurrencePaymentRequest&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,amount,paidAt,notes);

@override
String toString() {
  return 'OccurrencePaymentRequest(walletId: $walletId, amount: $amount, paidAt: $paidAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$OccurrencePaymentRequestCopyWith<$Res> implements $OccurrencePaymentRequestCopyWith<$Res> {
  factory _$OccurrencePaymentRequestCopyWith(_OccurrencePaymentRequest value, $Res Function(_OccurrencePaymentRequest) _then) = __$OccurrencePaymentRequestCopyWithImpl;
@override @useResult
$Res call({
 String? walletId,@DecimalConverter() Decimal? amount, String? paidAt, String? notes
});




}
/// @nodoc
class __$OccurrencePaymentRequestCopyWithImpl<$Res>
    implements _$OccurrencePaymentRequestCopyWith<$Res> {
  __$OccurrencePaymentRequestCopyWithImpl(this._self, this._then);

  final _OccurrencePaymentRequest _self;
  final $Res Function(_OccurrencePaymentRequest) _then;

/// Create a copy of OccurrencePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? walletId = freezed,Object? amount = freezed,Object? paidAt = freezed,Object? notes = freezed,}) {
  return _then(_OccurrencePaymentRequest(
walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
