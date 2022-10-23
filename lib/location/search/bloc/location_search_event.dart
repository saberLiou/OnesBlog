part of 'location_search_bloc.dart';

abstract class LocationSearchEvent {
  const LocationSearchEvent();
}

class TextChanged extends LocationSearchEvent {
  const TextChanged({
    required this.keyword,
  });

  final String keyword;

  @override
  List<Object> get props => [keyword];

  @override
  String toString() => 'TextChanged { keyword: $keyword }';
}
