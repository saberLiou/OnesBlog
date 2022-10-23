import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the location.
class LocationException implements Exception {}

/// {@template location_repository}
/// A Dart Repository of the Location domain.
/// {@endtemplate}
class LocationRepository {
  /// {@macro location_repository}
  LocationRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'locations';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Returns a list of locations.
  ///
  /// Throws a [LocationException] if an error occurs.
  Future<List<Location>> listLocations({
    required int categoryId,
    int limit = 10,
    String? keyword,
  }) async {
    final queryParams = {
      'category_id': categoryId.toString(),
      'limit': limit.toString(),
      if (keyword != null) ...{
        'keyword': keyword,
      },
    };
    try {
      return (await _onesBlogApiClient.index(
        uri: _endpoint,
        queryParams: queryParams,
      ))
          .map(
            (dynamic model) => Location.fromJson(model as Map<String, dynamic>),
          )
          .toList();
    } on Exception {
      throw LocationException();
    }
  }
}
