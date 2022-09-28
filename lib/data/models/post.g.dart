part of 'post.dart';

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'slug': instance.slug,
    };
