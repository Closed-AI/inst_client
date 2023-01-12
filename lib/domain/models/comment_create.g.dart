// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentCreate _$CommentCreateFromJson(Map<String, dynamic> json) =>
    CommentCreate(
      postId: json['postId'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$CommentCreateToJson(CommentCreate instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'text': instance.text,
    };
