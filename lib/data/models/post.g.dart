part of 'post.dart';

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      title: json['title'] as String,
      content: json['content'] as String?,
      publishedAt: json['published_at'] as String,
      createdAt: json['created_at'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'location': instance.location?.toJson(),
      'title': instance.title,
      'content': instance.content,
      'published_at': instance.publishedAt,
      'created_at': instance.createdAt,
      'slug': instance.slug,
    };
