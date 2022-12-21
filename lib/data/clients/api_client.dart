import 'package:dio/dio.dart';
import 'package:inst_client/domain/models/post_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/models/user.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
      @Query("skip") int skip, @Query("take") int take);
}
