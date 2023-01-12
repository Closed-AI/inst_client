import 'dart:io';

import 'package:inst_client/data/clients/api_client.dart';
import 'package:inst_client/data/clients/auth_client.dart';
import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/domain/models/create_post_model.dart';
import 'package:inst_client/domain/models/create_user.dart';
import 'package:inst_client/domain/models/post_model.dart';
import 'package:inst_client/domain/models/refresh_token_request.dart';
import 'package:inst_client/domain/models/token_request.dart';
import 'package:inst_client/domain/models/token_response.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:inst_client/domain/repository/api_repository.dart';

import '../../domain/models/comment.dart';
import '../../domain/models/comment_create.dart';

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
  Future createUser(CreateUser model) async {
    await _auth.registerUser(model);
  }

  @override
  Future likePost(String postId) async => await _api.likePost(postId);

  @override
  Future<User?> getUserById(String userId) => _api.getUserById(userId);

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<List<User>> getUsers() => _api.getUsers();

  @override
  Future writeComment(String postId, String text) =>
      _api.writeComment(CommentCreate(postId: postId, text: text));

  @override
  Future deleteComment(String commentId) => _api.deleteComment(commentId);

  @override
  Future<List<Comment>> getPostComments(String postId) async =>
      await _api.getPostComments(postId);

  @override
  Future createPost(CreatePostModel model) async {
    await _api.createPost(model);
  }

  @override
  Future<List<PostModel>> getPosts(int skip, int take) =>
      _api.getPosts(skip, take);

  @override
  Future subscribe(String targetId) => _api.subscribe(targetId);

  @override
  Future<bool> isSubscibed(String targetId, String subId) =>
      _api.isSubscribed(targetId, subId);

  @override
  Future<List<User>> getSubscribtions(String userId) =>
      _api.getSubscribtions(userId);

  @override
  Future<List<User>> getSubscribers(String userId) =>
      _api.getSubscribers(userId);

  @override
  Future<List<PostModel>> getUserPosts(String userId, int skip, int take) =>
      _api.getUserPosts(userId, skip, take);

  @override
  Future<List<PostModel>> getLikedPosts(String userId, int skip, int take) =>
      _api.getLikedPosts(userId, skip, take);

  @override
  Future<List<AttachMeta>> uploadTemp({required List<File> files}) =>
      _api.uploadTemp(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);
}
