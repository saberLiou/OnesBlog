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
    required int categoryId,
    int limit = 10,
  }) async {
    final queryParams = {
      'category_id': categoryId.toString(),
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

  /// Verify code for a registered user.
  ///
  /// Throws a [PostException] if an error occurs.
  Future<Post> store({
    required String? token,
    required int locationId,
    required String title,
    String? content,
  }) async {
    try {
      return Post.fromJson(
        await _onesBlogApiClient.store(
          uri: _endpoint,
          inputParams: {
            'location_id': locationId.toString(),
            'title': title,
            'content': content,
            'published_at': DateTime.now().toString(),
          },
          token: token,
        ) as Map<String, dynamic>,
      );
    } on Exception {
      throw PostException();
    }
  }
}
