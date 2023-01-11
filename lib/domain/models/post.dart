import 'package:inst_client/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String description;
  final String? authorId;
  final int likeCount;
  Post({
    required this.id,
    required this.description,
    this.authorId,
    required this.likeCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);

  Post copyWith({
    String? id,
    String? description,
    String? authorId,
    int? likeCount,
  }) {
    return Post(
        id: id ?? this.id,
        description: description ?? this.description,
        authorId: authorId ?? this.authorId,
        likeCount: likeCount ?? this.likeCount);
  }
}
