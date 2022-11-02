import 'package:ones_blog/data/models/location_score.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the location.
class LocationScoreException implements Exception {}

/// {@template location_score_repository}
/// A Dart Repository of the LocationScore domain.
/// {@endtemplate}
class LocationScoreRepository {
  /// {@macro location_score_repository}
  LocationScoreRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'location-scores';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Returns a list of location scores.
  ///
  /// Throws a [LocationScoreException] if an error occurs.
  Future<List<LocationScore>> listLocationScores({
    int? locationId,
    int? userId,
  }) async {
    try {
      return (await _onesBlogApiClient.index(
        uri: _endpoint,
        queryParams: {
          if (locationId != null) ...{
            'location_id': locationId.toString(),
          },
          if (userId != null) ...{
            'user_id': userId.toString(),
          },
        },
      ))
          .map(
            (dynamic model) => LocationScore.fromJson(
              model as Map<String, dynamic>,
            ),
          )
          .toList();
    } on Exception {
      throw LocationScoreException();
    }
  }

  /// Store a location score.
  ///
  /// Throws a [LocationScoreException] if an error occurs.
  Future<LocationScore> store({
    required int locationId,
    required double score,
    required String? token,
  }) async {
    try {
      return LocationScore.fromJson(
        await _onesBlogApiClient.store(
          uri: 'locations/$locationId/$_endpoint',
          inputParams: {
            'score': score.toString(),
          },
          token: token,
        ) as Map<String, dynamic>,
      );
    } on Exception {
      throw LocationScoreException();
    }
  }
}
