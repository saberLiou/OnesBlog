part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      loginTypeId: json['login_type_id'] as int?,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      locationAppliedAt: json['location_applied_at'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'login_type_id': instance.loginTypeId,
      'location': instance.location?.toJson(),
      'location_applied_at': instance.locationAppliedAt,
      'token': instance.token,
    };
