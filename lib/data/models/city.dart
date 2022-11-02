import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/city_area.dart';

part 'city.g.dart';

/// {@template city}
/// City description
/// {@endtemplate}
class City extends Equatable {
  /// {@macro city}
  const City({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
    this.cityAreas,
  });

  /// Creates a City from Json map
  factory City.fromJson(Map<String, dynamic> data) => _$CityFromJson(data);

  /// A description for id
  final int id;

  /// A description for createdAt
  final String createdAt;

  /// A description for updatedAt
  final String updatedAt;

  /// A description for city
  final String city;

  /// A description for cityAreas
  final List<CityArea>? cityAreas;

  /// Creates a copy of the current City with property changes
  City copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? city,
    List<CityArea>? cityAreas,
  }) {
    return City(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      city: city ?? this.city,
      cityAreas: cityAreas ?? this.cityAreas,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        city,
        cityAreas,
      ];

  /// Creates a Json map from a City
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
