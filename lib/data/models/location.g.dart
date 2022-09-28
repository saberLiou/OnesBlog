part of 'location.dart';

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      userId: json['user_id'] as int,
      cityAreaId: json['city_area_id'] as int,
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      avgScore: double.parse(json['avgScore'].toString()),
      introduction: json['introduction'] as String,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{ 
      'user_id': instance.userId,
      'city_area_id': instance.cityAreaId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'avgScore': instance.avgScore,
      'introduction': instance.introduction,
    };
