part of 'location_search_bloc.dart';

abstract class LocationSearchState extends Equatable {
  const LocationSearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends LocationSearchState {}

class SearchStateLoading extends LocationSearchState {}

class SearchStateSuccess extends LocationSearchState {
  const SearchStateSuccess(this.items);

  final List<Location> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends LocationSearchState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
