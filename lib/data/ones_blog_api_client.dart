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

  static const _baseUrl = 'ones-blog.tw';
  static const _endpointPrefix = '/api/';
  final http.Client _httpClient;

  String _prefix(String uri) => _endpointPrefix + uri;

  Future<List<dynamic>> index({
    required String uri,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _get(
      uri: Uri.https(_baseUrl, _prefix(uri), queryParams),
    );

    try {
      return response.data as List;
    } catch (_) {
      throw JsonDeserializationException();
    }
  }

  Future<dynamic> get({
    required String uri,
    String? token,
  }) async =>
      (await _get(
        uri: Uri.https(_baseUrl, _prefix(uri)),
        token: token,
      ))
          .data;

  Future<dynamic> store({
    required String uri,
    required Map<String, dynamic>? inputParams,
    String? token,
    List<String>? images,
  }) async =>
      (await _post(
        Uri.https(_baseUrl, _prefix(uri)),
        inputParams,
        token,
        images,
      ))
          .data;

  Future<dynamic> update({
    required String uri,
    required Map<String, dynamic>? inputParams,
    String? token,
    List<String>? images,
  }) async =>
      (await _put(
        Uri.https(_baseUrl, _prefix(uri)),
        inputParams,
        token,
        images,
      ))
          .data;

  Future<dynamic> delete({
    required String uri,
    String? token,
  }) async =>
      (await _delete(
        Uri.https(_baseUrl, _prefix(uri)),
        token,
      ))
          .data;

  Future<Response> _get({required Uri uri, String? token}) async {
    http.Response response;

    try {
      response = await _httpClient.get(
        uri,
        headers: {
          HttpHeaders.acceptHeader: ContentType.json.toString(),
          if (token != null) ...{
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }
        },
      );
    } catch (_) {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    return _decodeResponseBody(response.body);
  }

  Future<Response> _post(
    Uri uri,
    Map<String, dynamic>? body,
    String? token,
    List<String>? images,
  ) async {
    final headers = {
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      if (token != null) ...{
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      if (images != null) ...{
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      }
    };
    int responseStatusCode;
    String responseBody;

    try {
      if (images == null) {
        final response = await _httpClient.post(
          uri,
          headers: headers,
          body: body,
        );
        responseStatusCode = response.statusCode;
        responseBody = response.body;
      } else {
        final request = http.MultipartRequest('POST', uri)
          ..headers.addAll(headers);
        body?.forEach((key, value) => request.fields[key] = value.toString());
        for (final imagePath in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', imagePath),
          );
        }
        final response = await request.send();
        responseStatusCode = response.statusCode;
        responseBody = await response.stream.bytesToString();
      }
    } catch (_) {
      throw HttpException();
    }

    if (![200, 201].contains(responseStatusCode)) {
      throw HttpRequestFailure(responseStatusCode);
    }

    return _decodeResponseBody(responseBody);
  }

  Future<Response> _put(
    Uri uri,
    Map<String, dynamic>? body,
    String? token,
    List<String>? images,
  ) async {
    final headers = {
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      if (token != null) ...{
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      if (images != null) ...{
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      }
    };
    int responseStatusCode;
    String responseBody;

    try {
      if (images == null) {
        final response = await _httpClient.put(
          uri,
          headers: headers,
          body: body,
        );
        responseStatusCode = response.statusCode;
        responseBody = response.body;
      } else {
        final request = http.MultipartRequest('POST', uri)
          ..headers.addAll(headers);
        if (body != null) {
          body['_method'] = 'PUT';
          body.forEach((key, value) => request.fields[key] = value.toString());
        }
        for (final imagePath in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', imagePath),
          );
        }
        final response = await request.send();
        responseStatusCode = response.statusCode;
        responseBody = await response.stream.bytesToString();
      }
    } catch (_) {
      throw HttpException();
    }

    if (responseStatusCode != 200) {
      throw HttpRequestFailure(responseStatusCode);
    }

    return _decodeResponseBody(responseBody);
  }

  Future<Response> _delete(
    Uri uri,
    String? token,
  ) async {
    http.Response response;

    try {
      response = await _httpClient.delete(
        uri,
        headers: {
          HttpHeaders.acceptHeader: ContentType.json.toString(),
          if (token != null) ...{
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }
        },
      );
    } catch (_) {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    return _decodeResponseBody(response.body);
  }

  Response _decodeResponseBody(String body) {
    try {
      return Response.fromJson(
        jsonDecode(body) as Map<String, dynamic>,
      );
    } catch (_) {
      throw JsonDecodeException();
    }
  }
}
