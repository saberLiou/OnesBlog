import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/user.dart';

part 'location.g.dart';

/// {@template location}
/// Location description
/// {@endtemplate}
class Location extends Equatable {
  /// {@macro location}
  const Location({
    required this.id,
    required this.user,
    required this.cityAreaId,
    required this.categoryId,
    required this.name,
    required this.cityAndArea,
    required this.address,
    required this.phone,
    required this.avgScore,
    required this.introduction,
  });

  /// Creates a Location from Json map
  factory Location.fromJson(Map<String, dynamic> data) =>
      _$LocationFromJson(data);

  /// A description for id
  final int id;

  /// A description for user
  final User? user;

  /// A description for cityAreaId
  final int cityAreaId;

  /// A description for categoryId
  final int categoryId;

  /// A description for name
  final String name;

  /// A description for cityAndArea
  final String? cityAndArea;

  /// A description for address
  final String address;

  /// A description for phone
  final String phone;

  /// A description for avgScore
  final double avgScore;

  /// A description for introduction
  final String? introduction;

  /// Creates a copy of the current Location with property changes
  Location copyWith({
    int? id,
    User? user,
    int? cityAreaId,
    int? categoryId,
    String? name,
    String? cityAndArea,
    String? address,
    String? phone,
    double? avgScore,
    String? introduction,
  }) {
    return Location(
      id: id ?? this.id,
      user: user ?? this.user,
      cityAreaId: cityAreaId ?? this.cityAreaId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      cityAndArea: cityAndArea ?? this.cityAndArea,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      avgScore: avgScore ?? this.avgScore,
      introduction: introduction ?? this.introduction,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        cityAreaId,
        categoryId,
        name,
        cityAndArea,
        address,
        phone,
        avgScore,
        introduction,
      ];

  /// Creates a Json map from a Location
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
