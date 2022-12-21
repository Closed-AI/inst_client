import 'dart:io';

import 'package:inst_client/data/services/data_service.dart';
import 'package:inst_client/domain/repository/api_repository.dart';
import 'package:inst_client/internal/config/shared_prefs.dart';
import 'package:inst_client/internal/config/token_storage.dart';
import 'package:inst_client/internal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiRepository _api = RepositoryModule.apiRepository();
  final DataService _dataService = DataService();

  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      try {
        var token = await _api.getToken(login: login, password: password);
        if (token != null) {
          await TokenStorage.setStoredToken(token);
          var user = await _api.getUser();
          if (user != null) {
            SharedPrefs.setStoredUser(user);
          }
        }
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[401].contains(e.response?.statusCode)) {
          throw WrongCredentionalException();
        } else if (<int>[500].contains(e.response?.statusCode)) {
          throw ServerException();
        }
      }
    }
  }

  Future<bool> checkAuth() async {
    var res = false;

    if (await TokenStorage.getAccessToken() != null) {
      var user = await _api.getUser();
      if (user != null) {
        await SharedPrefs.setStoredUser(user);
        await _dataService.cuUser(user);
      }

      res = true;
    }

    return res;
  }

  Future logout() async {
    await TokenStorage.setStoredToken(null);
  }
}

class WrongCredentionalException implements Exception {}

class NoNetworkException implements Exception {}

class ServerException implements Exception {}
