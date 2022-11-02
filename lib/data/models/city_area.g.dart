part of 'city_area.dart';

CityArea _$CityAreaFromJson(Map<String, dynamic> json) => CityArea(
      id: json['id'] as int,
      cityId: json['city_id'] as int?,
      city: json['city'] != null
          ? City.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      cityArea: json['city_area'] as String,
      zipCode: json['zip_code'] as String?,
    );

Map<String, dynamic> _$CityAreaToJson(CityArea instance) => <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'city_id': instance.cityId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'city_area': instance.cityArea,
      'zip_code': instance.zipCode,
    };
