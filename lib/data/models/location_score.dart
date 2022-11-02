import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/user.dart';

part 'location_score.g.dart';

/// {@template location_score}
/// LocationScore description
/// {@endtemplate}
class LocationScore extends Equatable {
  /// {@macro location_score}
  const LocationScore({
    required this.user,
    required this.location,
    required this.score,
  });

  /// Creates a LocationScore from Json map
  factory LocationScore.fromJson(Map<String, dynamic> data) =>
      _$LocationScoreFromJson(data);

  /// A description for user
  final User user;

  /// A description for location
  final Location location;

  /// A description for score
  final double score;

  /// Creates a copy of the current LocationScore with property changes
  LocationScore copyWith({
    User? user,
    Location? location,
    double? score,
  }) {
    return LocationScore(
      user: user ?? this.user,
      location: location ?? this.location,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [
        user,
        location,
        score,
      ];

  /// Creates a Json map from a LocationScore
  Map<String, dynamic> toJson() => _$LocationScoreToJson(this);
}
