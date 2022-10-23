import 'package:equatable/equatable.dart';

part 'post.g.dart';

/// {@template post}
/// Post description
/// {@endtemplate}
class Post extends Equatable {
  /// {@macro post}
  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    required this.createdAt,
    required this.slug,
  });

  /// Creates a Post from Json map
  factory Post.fromJson(Map<String, dynamic> data) => _$PostFromJson(data);

  /// A description for id
  final int? id;

  /// A description for title
  final String title;

  /// A description for content
  final String content;

  /// A description for published_at
  final String publishedAt;

  /// A description for created_at
  final String createdAt;

  /// A description for slug
  final String slug;

  /// Creates a copy of the current Post with property changes
  Post copyWith({
    int? id,
    String? title,
    String? content,
    String? publishedAt,
    String? createdAt,
    String? slug,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      slug: slug ?? this.slug,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        publishedAt,
        createdAt,
        slug,
      ];

  /// Creates a Json map from a Post
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
