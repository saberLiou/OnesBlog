part of 'post_keep.dart';

PostKeep _$PostKeepFromJson(Map<String, dynamic> json) => PostKeep(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      post: Post.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostKeepToJson(PostKeep instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'post': instance.post,
    };
