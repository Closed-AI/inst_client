import 'dart:io';

import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/domain/models/post_model.dart';

import '../models/token_response.dart';
import '../models/user.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});
  Future<TokenResponse?> refreshToken(String refreshToken);
  Future<User?> getUser();
  Future<List<PostModel>> getPosts(int skip, int take);
  Future<List<AttachMeta>> uploadTemp({required List<File> files});
  Future addAvatarToUser(AttachMeta model);
}
