import 'dart:io';

import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/domain/models/create_user.dart';
import 'package:inst_client/domain/models/post_model.dart';

import '../models/create_post_model.dart';
import '../models/token_response.dart';
import '../models/user.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});
  Future<TokenResponse?> refreshToken(String refreshToken);
  Future createUser(CreateUser model);
  Future<User?> getUser();
  Future<List<User>> getUsers();
  Future createPost(CreatePostModel model);
  Future likePost(String postId);
  Future<List<PostModel>> getPosts(int skip, int take);
  //---------------- subs section ----------------
  Future subscribe(String targetId);
  Future<bool> isSubscibed(String targetId, String subId);
  Future<List<User>> getSubscribtions(String userId);
  Future<List<User>> getSubscribers(String userId);
  //----------------------------------------------
  Future<List<PostModel>> getUserPosts(String userId, int skip, int take);
  Future<List<PostModel>> getLikedPosts(String userId, int skip, int take);
  Future<List<AttachMeta>> uploadTemp({required List<File> files});
  Future addAvatarToUser(AttachMeta model);
}
