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
  Future createPost(CreatePostModel model);
  Future<List<PostModel>> getPosts(int skip, int take);
  Future<List<AttachMeta>> uploadTemp({required List<File> files});
  Future addAvatarToUser(AttachMeta model);
}
