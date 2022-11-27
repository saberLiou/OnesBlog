part of 'location.dart';

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      id: json['id'] as int,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      cityAreaId: int.parse(json['city_area_id'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      name: json['name'] as String,
      cityAndArea: json['city_and_area'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String,
      avgScore: double.parse(json['avgScore'].toString()),
      introduction: json['introduction'] as String?,
      images: (json['images'] as List)
          .map((dynamic model) => model as String)
          .toList(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'city_area_id': instance.cityAreaId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'city_and_area': instance.cityAndArea,
      'address': instance.address,
      'phone': instance.phone,
      'avgScore': instance.avgScore,
      'introduction': instance.introduction,
      'images': instance.images,
    };
