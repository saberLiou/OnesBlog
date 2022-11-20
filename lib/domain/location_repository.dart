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
    int? cityId,
    int? random,
    int? ranking,
    int limit = 10,
    String? keyword,
  }) async {
    final queryParams = {
      'category_id': categoryId.toString(),
      if (cityId != null) ...{
        'city_id': cityId.toString(),
      },
      if (random != null) ...{
        'random': random.toString(),
      },
      if (ranking != null) ...{
        'ranking': ranking.toString(),
      },
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

  /// Get a location.
  ///
  /// Throws a [LocationException] if an error occurs.
  Future<Location?> getLocation(int id) async {
    try {
      return Location.fromJson(
        await _onesBlogApiClient.get(uri: '$_endpoint/$id') as Map<String, dynamic>,
      );
    } on Exception {
      throw LocationException();
    }
  }

  /// Store a location.
  ///
  /// Throws a [LocationException] if an error occurs.
  Future<Location> store({
    required int? id,
    required String? token,
    required int cityAreaId,
    required int categoryId,
    required String name,
    required String address,
    required String phone,
    String? introduction,
  }) async {
    try {
      return Location.fromJson(
        (id == null
            ? await _onesBlogApiClient.store(
                uri: _endpoint,
                inputParams: {
                  'city_area_id': cityAreaId.toString(),
                  'category_id': categoryId.toString(),
                  'name': name,
                  'address': address,
                  'phone': phone,
                  'introduction': introduction,
                },
                token: token,
              )
            : await _onesBlogApiClient.update(
                uri: '$_endpoint/$id',
                inputParams: {
                  'city_area_id': cityAreaId.toString(),
                  'category_id': categoryId.toString(),
                  'name': name,
                  'address': address,
                  'phone': phone,
                  'introduction': introduction,
                },
                token: token,
              )) as Map<String, dynamic>,
      );
    } on Exception {
      throw LocationException();
    }
  }

  /// Returns a list of location likes of the user.
  ///
  /// Throws a [LocationException] if an error occurs.
  Future<List<Location>> listLocationLikes(int userId) async {
    try {
      return (await _onesBlogApiClient.index(
        uri: 'location-likes',
        queryParams: {
          'user_id': userId.toString(),
        },
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
