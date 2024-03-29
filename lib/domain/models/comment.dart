// Generated by https://quicktype.io

import 'package:inst_client/domain/models/post_content.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  String id;
  String postId;
  String authorId;
  String text;
  DateTime creatingDate;
  int likeCount;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.text,
    required this.creatingDate,
    required this.likeCount,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
