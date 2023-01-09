import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/domain/models/post_content.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_post_model.g.dart';

@JsonSerializable()
class CreatePostModel {
  String authorId;
  String? description;
  List<AttachMeta> contents;

  CreatePostModel({
    required this.authorId,
    this.description,
    required this.contents,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);
}
