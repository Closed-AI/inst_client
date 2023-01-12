// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      text: json['text'] as String,
      creatingDate: DateTime.parse(json['creatingDate'] as String),
      likeCount: json['likeCount'] as int,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'text': instance.text,
      'creatingDate': instance.creatingDate.toIso8601String(),
      'likeCount': instance.likeCount,
    };
