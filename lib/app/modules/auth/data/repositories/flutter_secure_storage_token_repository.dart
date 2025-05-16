import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:rxdart/subjects.dart';

class Token {
  final String token;
  final DateTime expiredAt;

  Token({required this.token, required this.expiredAt});
}

@Injectable(as: TokenRepository)
class FlutterSecureStorageTokenRepository implements TokenRepository {
  final FlutterSecureStorage _storage;
  final String _tokenKey = 'token';
  final String _expiredAtKey = 'expiredAt';
  final String _refreshTokenKey = 'refreshToken';
  final String _refreshExpiredAtKey = 'refreshExpiredAt';

  final _subject = BehaviorSubject<Token?>();
  final _refreshSubject = BehaviorSubject<Token?>();

  FlutterSecureStorageTokenRepository(this._storage);

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final token = await _storage.read(key: _tokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final expiredAt = await _storage.read(key: _expiredAtKey);
    final refreshExpiredAt = await _storage.read(key: _refreshExpiredAtKey);

    if (token != null && expiredAt != null) {
      saveToken(
        token,
        duration: DateTime.parse(expiredAt).difference(DateTime.now()),
      );
      if (refreshToken != null && refreshExpiredAt != null) {
        saveRefreshToken(
          refreshToken,
          duration: DateTime.parse(refreshExpiredAt).difference(DateTime.now()),
        );
      }
    } else {
      deleteToken();
    }
  }

  @disposeMethod
  static FutureOr dispose(TokenRepository repository) {
    (repository as FlutterSecureStorageTokenRepository)
      .._subject.close()
      .._refreshSubject.close();
  }

  @override
  Future<void> deleteToken() async {
    _subject.add(null);
    _refreshSubject.add(null);
    _storage.delete(key: _tokenKey);
    _storage.delete(key: _expiredAtKey);
    _storage.delete(key: _refreshTokenKey);
    _storage.delete(key: _refreshExpiredAtKey);
  }

  @override
  Stream<String?> get refreshToken =>
      _refreshSubject.stream.map((token) => token?.token);

  @override
  DateTime? get refreshTokenExpiration => _refreshSubject.value?.expiredAt;

  @override
  Future<void> saveRefreshToken(
    String token, {
    Duration duration = const Duration(days: 180),
  }) async {
    _refreshSubject.add(
      Token(token: token, expiredAt: DateTime.now().add(duration)),
    );
    await _storage.write(key: _refreshTokenKey, value: token);
    await _storage.write(
      key: _refreshExpiredAtKey,
      value: DateTime.now().add(duration).toIso8601String(),
    );
  }

  @override
  Future<void> saveToken(
    String token, {
    Duration duration = const Duration(seconds: 3600),
  }) async {
    _subject.add(Token(token: token, expiredAt: DateTime.now().add(duration)));
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(
      key: _expiredAtKey,
      value: DateTime.now().add(duration).toIso8601String(),
    );
  }

  @override
  Stream<String?> get token => _subject.stream.map((token) => token?.token);

  @override
  DateTime? get tokenExpiration => _subject.value?.expiredAt;
}
