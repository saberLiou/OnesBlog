part of 'city.dart';

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      city: json['city'] as String,
      cityAreas: json['city_areas'] != null
          ? (json['city_areas'] as List)
              .map(
                (dynamic model) =>
                    CityArea.fromJson(model as Map<String, dynamic>),
              )
              .toList()
          : null,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'city': instance.city,
      'city_areas': instance.cityAreas,
    };
