import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the location.
class PostException implements Exception {}

/// {@template post_repository}
/// A Dart Repository of the Post domain.
/// {@endtemplate}
class PostRepository {
  /// {@macro post_repository}
  PostRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'posts';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Returns a list of posts.
  ///
  /// Throws a [PostException] if an error occurs.
  Future<List<Post>> listPosts({
    int? categoryId,
    int? locationId,
    int? userId,
    int limit = 10,
  }) async {
    final queryParams = {
      if (categoryId != null) ... {
        'category_id': categoryId.toString(),
      },
      if (locationId != null) ...{
        'location_id': locationId.toString(),
      },
      if (userId != null) ...{
        'user_id': userId.toString(),
      },
      'limit': limit.toString(),
    };
    try {
      return (await _onesBlogApiClient.index(
        uri: _endpoint,
        queryParams: queryParams,
      ))
          .map(
            (dynamic model) => Post.fromJson(model as Map<String, dynamic>),
          )
          .toList();
    } on Exception {
      throw PostException();
    }
  }

  /// Store a post.
  ///
  /// Throws a [PostException] if an error occurs.
  Future<Post> store({
    required int? id,
    required String? token,
    required int locationId,
    required String title,
    String? content,
  }) async {
    try {
      return Post.fromJson(
        (id == null
            ? await _onesBlogApiClient.store(
                uri: _endpoint,
                inputParams: {
                  'location_id': locationId.toString(),
                  'title': title,
                  'content': content,
                  'published_at': DateTime.now().toString(),
                },
                token: token,
              )
            : await _onesBlogApiClient.update(
                uri: '$_endpoint/$id',
                inputParams: {
                  'location_id': locationId.toString(),
                  'title': title,
                  'content': content,
                  'published_at': DateTime.now().toString(),
                },
                token: token,
              )) as Map<String, dynamic>,
      );
    } on Exception {
      throw PostException();
    }
  }

  /// Delete a post.
  ///
  /// Throws a [PostException] if an error occurs.
  Future<void> delete({
    required int id,
    required String? token,
  }) async {
    try {
      await _onesBlogApiClient.delete(
        uri: '$_endpoint/$id',
        token: token,
      );
    } on Exception {
      throw PostException();
    }
  }

  /// Returns a list of post keeps of the user.
  ///
  /// Throws a [PostException] if an error occurs.
  Future<List<Post>> listPostKeeps(int userId) async {
    try {
      return (await _onesBlogApiClient.index(
        uri: 'post-keeps',
        queryParams: {
          'user_id': userId.toString(),
        },
      ))
          .map(
            (dynamic model) => Post.fromJson(model as Map<String, dynamic>),
          )
          .toList();
    } on Exception {
      throw PostException();
    }
  }
}
