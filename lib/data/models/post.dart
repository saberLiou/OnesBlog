import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/user.dart';

part 'post.g.dart';

/// {@template post}
/// Post description
/// {@endtemplate}
class Post extends Equatable {
  /// {@macro post}
  const Post({
    required this.id,
    required this.user,
    required this.location,
    required this.title,
    required this.content,
    required this.publishedAt,
    required this.createdAt,
    required this.slug,
  });

  /// Creates a Post from Json map
  factory Post.fromJson(Map<String, dynamic> data) => _$PostFromJson(data);

  /// A description for id
  final int id;

  /// A description for user
  final User? user;

  /// A description for location
  final Location? location;

  /// A description for title
  final String title;

  /// A description for content
  final String? content;

  /// A description for published_at
  final String publishedAt;

  /// A description for created_at
  final String createdAt;

  /// A description for slug
  final String slug;

  /// Creates a copy of the current Post with property changes
  Post copyWith({
    int? id,
    User? user,
    Location? location,
    String? title,
    String? content,
    String? publishedAt,
    String? createdAt,
    String? slug,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      location: location ?? this.location,
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
        user,
        location,
        title,
        content,
        publishedAt,
        createdAt,
        slug,
      ];

  /// Creates a Json map from a Post
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
