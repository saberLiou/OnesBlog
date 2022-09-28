import 'package:equatable/equatable.dart';

part 'location.g.dart';

/// {@template location}
/// Location description
/// {@endtemplate}
class Location extends Equatable {
  /// {@macro location}
  const Location({ 
    required this.userId,
    required this.cityAreaId,
    required this.categoryId,
    required this.name,
    required this.address,
    required this.phone,
    required this.avgScore,
    required this.introduction,
  });

  /// Creates a Location from Json map
  factory Location.fromJson(Map<String, dynamic> data) => _$LocationFromJson(data);

  /// A description for userId
  final int userId;
  /// A description for cityAreaId
  final int cityAreaId;
  /// A description for categoryId
  final int categoryId;
  /// A description for name
  final String name;
  /// A description for address
  final String address;
  /// A description for phone
  final String phone;
  /// A description for avgScore
  final double avgScore;
  /// A description for introduction
  final String introduction;

  /// Creates a copy of the current Location with property changes
  Location copyWith({ 
    int? userId,
    int? cityAreaId,
    int? categoryId,
    String? name,
    String? address,
    String? phone,
    double? avgScore,
    String? introduction,
  }) {
    return Location(
      userId: userId ?? this.userId,
      cityAreaId: cityAreaId ?? this.cityAreaId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      avgScore: avgScore ?? this.avgScore,
      introduction: introduction ?? this.introduction,
    );
  }
  
  @override
  List<Object?> get props => [
        userId,
        cityAreaId,
        categoryId,
        name,
        address,
        phone,
        avgScore,
        introduction,
      ];

  /// Creates a Json map from a Location
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
