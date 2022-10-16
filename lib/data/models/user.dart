import 'package:equatable/equatable.dart';

part 'user.g.dart';

/// {@template user}
/// User description
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({ 
    required this.name,
    required this.email,
    required this.token,
  });

  /// Creates a User from Json map
  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  /// A description for name
  final String name;
  /// A description for email
  final String email;
  /// A description for token
  final String? token;

  /// Creates a copy of the current User with property changes
  User copyWith({ 
    String? name,
    String? email,
    String? token,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
  
  @override
  List<Object?> get props => [
        name,
        email,
        token,
      ];

  /// Creates a Json map from a User
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
