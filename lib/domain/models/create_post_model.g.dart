// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostModel _$CreatePostModelFromJson(Map<String, dynamic> json) =>
    CreatePostModel(
      authorId: json['authorId'] as String,
      description: json['description'] as String?,
      contents: (json['contents'] as List<dynamic>)
          .map((e) => AttachMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreatePostModelToJson(CreatePostModel instance) =>
    <String, dynamic>{
      'authorId': instance.authorId,
      'description': instance.description,
      'contents': instance.contents,
    };
