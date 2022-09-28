import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while listing posts.
class PostsException implements Exception {}

/// {@template post_repository}
/// A Dart Repository of the Post domain.
/// {@endtemplate}
class PostRepository {
  /// {@macro post_repository}
  PostRepository({OnesBlogApiClient? onesBlogApiClient})
    : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = '/posts';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Returns a list of posts.
  ///
  /// Throws a [PostsException] if an error occurs.
  Future<List<Post>> listPosts() {
    try {
      return _onesBlogApiClient.index(uri: _endpoint) as Future<List<Post>>;
    } on Exception {
      throw PostsException();
    }
  }
}
