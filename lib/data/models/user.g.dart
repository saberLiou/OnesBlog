part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{ 
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
    };
