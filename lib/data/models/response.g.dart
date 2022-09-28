part of 'response.dart';

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      data: json['data'] as dynamic,
      links: json['links'] as dynamic,
      meta: json['meta'] as dynamic,
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{ 
      'data': instance.data,
      'links': instance.links,
      'meta': instance.meta,
    };
