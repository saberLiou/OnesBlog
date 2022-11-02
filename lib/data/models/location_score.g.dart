part of 'location_score.dart';

LocationScore _$LocationScoreFromJson(Map<String, dynamic> json) =>
    LocationScore(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      score: double.parse(json['score'].toString()),
    );

Map<String, dynamic> _$LocationScoreToJson(LocationScore instance) =>
    <String, dynamic>{
      'user': instance.user,
      'location': instance.location,
      'score': instance.score,
    };
