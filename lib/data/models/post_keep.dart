import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/post.dart';
import 'package:ones_blog/data/models/user.dart';

part 'post_keep.g.dart';

/// {@template post_keep}
/// PostKeep description
/// {@endtemplate}
class PostKeep extends Equatable {
  /// {@macro post_keep}
  const PostKeep({
    required this.id,
    required this.user,
    required this.post,
  });

  /// Creates a PostKeep from Json map
  factory PostKeep.fromJson(Map<String, dynamic> data) =>
      _$PostKeepFromJson(data);

  /// A description for id
  final int id;

  /// A description for user
  final User user;

  /// A description for post
  final Post post;

  /// Creates a copy of the current PostKeep with property changes
  PostKeep copyWith({
    int? id,
    User? user,
    Post? post,
  }) {
    return PostKeep(
      id: id ?? this.id,
      user: user ?? this.user,
      post: post ?? this.post,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        post,
      ];

  /// Creates a Json map from a PostKeep
  Map<String, dynamic> toJson() => _$PostKeepToJson(this);
}
