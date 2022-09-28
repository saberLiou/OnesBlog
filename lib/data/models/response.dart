import 'package:equatable/equatable.dart';

part 'response.g.dart';

/// {@template response}
/// Response description
/// {@endtemplate}
class Response extends Equatable {
  /// {@macro response}
  const Response({ 
    required this.data,
    required this.links,
    required this.meta,
  });

  /// Creates a Response from Json map
  factory Response.fromJson(Map<String, dynamic> data) => _$ResponseFromJson(data);

  /// A description for data
  final dynamic data;
  /// A description for links
  final dynamic links;
  /// A description for meta
  final dynamic meta;

  /// Creates a copy of the current Response with property changes
  Response copyWith({ 
    dynamic data,
    dynamic links,
    dynamic meta,
  }) {
    return Response(
      data: data ?? this.data,
      links: links ?? this.links,
      meta: meta ?? this.meta,
    );
  }
  
  @override
  List<Object?> get props => [
        data,
        links,
        meta,
      ];

  /// Creates a Json map from a Response
  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
