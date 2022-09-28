import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ones_blog/data/models/response.dart';

/// Thrown if an exception occurs while making an `http` request.
class HttpException implements Exception {}

/// {@template http_request_failure}
/// Thrown if an `http` request returns a non-200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  const HttpRequestFailure(this.statusCode);

  /// The status code of the response.
  final int statusCode;
}

/// Thrown when an error occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown when an error occurs while deserializing the response body.
class JsonDeserializationException implements Exception {}

/// {@template ones_blog_api}
/// A Dart API Client for the [OnesBlog REST API](https://onesblog.herokuapp.com/api/).
/// {@endtemplate}
class OnesBlogApiClient {
  /// {@macro ones_blog_api}
  OnesBlogApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'onesblog.herokuapp.com';
  final http.Client _httpClient;

  Future<List<dynamic>> index({
    required String uri,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _get(Uri.https(_baseUrl, '/api/$uri', queryParams));

    try {
      return response.data as List;
    } catch (_) {
      throw JsonDeserializationException();
    }
  }

  Future<Response> _get(Uri uri) async {
    http.Response response;

    try {
      response = await _httpClient.get(
        uri,
        headers: {
          HttpHeaders.acceptHeader: ContentType.json.toString(),
        },
      );
    } catch (_) {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    try {
      return Response.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } catch (_) {
      throw JsonDecodeException();
    }
  }
}
