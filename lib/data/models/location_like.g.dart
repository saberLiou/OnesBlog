part of 'location_like.dart';

LocationLike _$LocationLikeFromJson(Map<String, dynamic> json) => LocationLike(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationLikeToJson(LocationLike instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'location': instance.location,
    };
