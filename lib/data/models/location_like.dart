import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/user.dart';

part 'location_like.g.dart';

/// {@template location_like}
/// LocationLike description
/// {@endtemplate}
class LocationLike extends Equatable {
  /// {@macro location_like}
  const LocationLike({
    required this.id,
    required this.user,
    required this.location,
  });

  /// Creates a LocationLike from Json map
  factory LocationLike.fromJson(Map<String, dynamic> data) =>
      _$LocationLikeFromJson(data);

  /// A description for id
  final int id;

  /// A description for user
  final User user;

  /// A description for location
  final Location location;

  /// Creates a copy of the current LocationLike with property changes
  LocationLike copyWith({
    int? id,
    User? user,
    Location? location,
  }) {
    return LocationLike(
      id: id ?? this.id,
      user: user ?? this.user,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        location,
      ];

  /// Creates a Json map from a LocationLike
  Map<String, dynamic> toJson() => _$LocationLikeToJson(this);
}
