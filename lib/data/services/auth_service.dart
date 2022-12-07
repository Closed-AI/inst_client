import 'dart:io';

import 'package:inst_client/domain/repository/api_repository.dart';
import 'package:inst_client/internal/config/shared_prefs.dart';
import 'package:inst_client/internal/config/token_storage.dart';
import 'package:inst_client/internal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiRepository _api = RepositoryModule.apiRepository();

  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      try {
        var token = await _api.getToken(login: login, password: password);
        if (token != null) {
          await TokenStorage.setStoredToken(token);
        }
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[401, 500].contains(e.response?.statusCode)) {
          throw WrongCredentionalExceprion();
        }
      }
    }
  }

  Future<bool> checkAuth() async {
    return (await TokenStorage.getAccessToken()) != null;
  }

  Future logout() async {
    await TokenStorage.setStoredToken(null);
  }
}

class WrongCredentionalExceprion implements Exception {}

class NoNetworkException implements Exception {}
