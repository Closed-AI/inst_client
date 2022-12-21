import 'package:inst_client/data/clients/api_client.dart';
import 'package:inst_client/data/clients/auth_client.dart';
import 'package:inst_client/domain/models/post_model.dart';
import 'package:inst_client/domain/models/refresh_token_request.dart';
import 'package:inst_client/domain/models/token_request.dart';
import 'package:inst_client/domain/models/token_response.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:inst_client/domain/repository/api_repository.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      password: password,
    ));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);
}
