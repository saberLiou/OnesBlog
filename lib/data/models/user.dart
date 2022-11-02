import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';

part 'user.g.dart';

/// {@template user}
/// User description
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.loginTypeId,
    required this.locationAppliedAt,
    required this.location,
    required this.token,
  });

  /// Creates a User from Json map
  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  /// A description for id
  final int id;

  /// A description for name
  final String name;

  /// A description for email
  final String email;

  /// A description for loginTypeId
  final int? loginTypeId;

  /// A description for locationAppliedAt
  final String? locationAppliedAt;

  /// A description for location
  final Location? location;

  /// A description for token
  final String? token;

  /// Creates a copy of the current User with property changes
  User copyWith({
    int? id,
    String? name,
    String? email,
    int? loginTypeId,
    String? locationAppliedAt,
    Location? location,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      loginTypeId: loginTypeId ?? this.loginTypeId,
      locationAppliedAt: locationAppliedAt ?? this.locationAppliedAt,
      location: location ?? this.location,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        loginTypeId,
        locationAppliedAt,
        location,
        token,
      ];

  /// Creates a Json map from a User
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
