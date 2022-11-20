import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the location like.
class LocationLikeException implements Exception {}

/// {@template location_like_repository}
/// A Dart Repository of the LocationLike domain.
/// {@endtemplate}
class LocationLikeRepository {
  /// {@macro location_like_repository}
  LocationLikeRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'location-likes';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Store or delete a location like.
  ///
  /// Throws a [LocationLikeException] if an error occurs.
  Future<void> store({
    required int locationId,
    required String? token,
  }) async {
    try {
      await _onesBlogApiClient.store(
        uri: 'locations/$locationId/$_endpoint',
        inputParams: {},
        token: token,
      );
    } on Exception {
      throw LocationLikeException();
    }
  }
}
