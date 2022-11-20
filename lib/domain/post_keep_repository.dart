import 'package:ones_blog/data/ones_blog_api_client.dart';

/// Thrown when an error occurs while manipulating the post keep.
class PostKeepException implements Exception {}

/// {@template post_keep_repository}
/// A Dart Repository of the PostKeep domain.
/// {@endtemplate}
class PostKeepRepository {
  /// {@macro post_keep_repository}
  PostKeepRepository({OnesBlogApiClient? onesBlogApiClient})
      : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  static const _endpoint = 'post-keeps';
  final OnesBlogApiClient _onesBlogApiClient;

  /// Store or delete a post keep.
  ///
  /// Throws a [PostKeepException] if an error occurs.
  Future<void> store({
    required int postId,
    required String? token,
  }) async {
    try {
      await _onesBlogApiClient.store(
        uri: 'posts/$postId/$_endpoint',
        inputParams: {},
        token: token,
      );
    } on Exception {
      throw PostKeepException();
    }
  }
}
