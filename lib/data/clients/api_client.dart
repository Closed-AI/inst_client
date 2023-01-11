import 'dart:io';

import 'package:dio/dio.dart';
import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/domain/models/create_post_model.dart';
import 'package:inst_client/domain/models/post_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/models/user.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel body);

  @POST("/api/Post/LikePost")
  Future likePost(@Query("postId") String postId);

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
      @Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetUserPosts")
  Future<List<PostModel>> getUserPosts(@Query("userId") String userId,
      @Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetLikedPosts")
  Future<List<PostModel>> getLikedPosts(@Query("userId") String userId,
      @Query("skip") int skip, @Query("take") int take);

  @POST("/api/Attach/UploadFiles")
  Future<List<AttachMeta>> uploadTemp(
      {@Part(name: "files") required List<File> files});

  @POST("/api/User/AddAvatarToUser")
  Future addAvatarToUser(@Body() AttachMeta model);
}
