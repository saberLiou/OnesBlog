import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/city.dart';

part 'city_area.g.dart';

/// {@template city_area}
/// CityArea description
/// {@endtemplate}
class CityArea extends Equatable {
  /// {@macro city_area}
  const CityArea({
    required this.id,
    required this.cityId,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    required this.cityArea,
    required this.zipCode,
  });

  /// Creates a CityArea from Json map
  factory CityArea.fromJson(Map<String, dynamic> data) =>
      _$CityAreaFromJson(data);

  /// A description for id
  final int id;

  /// A description for cityId
  final int? cityId;

  /// A description for city
  final City? city;

  /// A description for createdAt
  final String? createdAt;

  /// A description for updatedAt
  final String? updatedAt;

  /// A description for cityArea
  final String cityArea;

  /// A description for zipCode
  final String? zipCode;

  /// Creates a copy of the current CityArea with property changes
  CityArea copyWith({
    int? id,
    int? cityId,
    City? city,
    String? createdAt,
    String? updatedAt,
    String? cityArea,
    String? zipCode,
  }) {
    return CityArea(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cityArea: cityArea ?? this.cityArea,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  @override
  List<Object?> get props => [
        id,
        cityId,
        city,
        createdAt,
        updatedAt,
        cityArea,
        zipCode,
      ];

  /// Creates a Json map from a CityArea
  Map<String, dynamic> toJson() => _$CityAreaToJson(this);
}
