import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/domain/models/post_content.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_create.g.dart';

@JsonSerializable()
class CommentCreate {
  String postId;
  String text;

  CommentCreate({
    required this.postId,
    required this.text,
  });

  factory CommentCreate.fromJson(Map<String, dynamic> json) =>
      _$CommentCreateFromJson(json);

  Map<String, dynamic> toJson() => _$CommentCreateToJson(this);
}
