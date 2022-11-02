import 'package:ones_blog/data/models/city_area.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the city area.
class CityAreaException implements Exception {}

/// {@template city_area_repository}
/// A Dart Repository of the CityArea domain.
/// {@endtemplate}
class CityAreaRepository {
  /// {@macro city_area_repository}
  CityAreaRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'city-areas';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Get the city area with its city.
  ///
  /// Throws a [CityAreaException] if an error occurs.
  Future<CityArea?> getCityArea(int id) async {
    try {
      return CityArea.fromJson(
        await _onesBlogApiClient.get(
          uri: '$_endpoint/$id',
        ) as Map<String, dynamic>,
      );
    } on Exception {
      throw CityAreaException();
    }
  }
}
