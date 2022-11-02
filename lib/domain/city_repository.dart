import 'package:ones_blog/data/models/city.dart';
import 'package:ones_blog/data/models/city_area.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the city.
class CityException implements Exception {}

/// {@template city_repository}
/// A Dart Repository of the City domain.
/// {@endtemplate}
class CityRepository {
  /// {@macro city_repository}
  CityRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'cities';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Returns a list of cities.
  ///
  /// Throws a [CityException] if an error occurs.
  Future<List<City>> listCities() async {
    try {
      return (await _onesBlogApiClient.index(
        uri: _endpoint,
      ))
          .map(
            (dynamic model) => City.fromJson(model as Map<String, dynamic>),
          )
          .toList();
    } on Exception {
      throw CityException();
    }
  }

  /// Returns a list of city areas by a city.
  ///
  /// Throws a [CityException] if an error occurs.
  Future<List<CityArea>?> getCityAreas(int cityId) async {
    try {
      return City.fromJson(
        await _onesBlogApiClient.get(
          uri: '$_endpoint/$cityId',
        ) as Map<String, dynamic>,
      ).cityAreas;
    } on Exception {
      throw CityException();
    }
  }
}
