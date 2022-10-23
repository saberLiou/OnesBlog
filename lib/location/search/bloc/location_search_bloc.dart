import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:stream_transform/stream_transform.dart';

part 'location_search_event.dart';

part 'location_search_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  LocationSearchBloc({
    required this.locationRepository,
    required this.locationCategory,
  }) : super(SearchStateEmpty()) {
    on<TextChanged>(_onTextChanged, transformer: debounce(_duration));
  }

  final LocationRepository locationRepository;
  final LocationCategory locationCategory;

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<LocationSearchState> emit,
  ) async {
    if (event.keyword.isEmpty) return emit(SearchStateEmpty());

    emit(SearchStateLoading());

    try {
      final locations = await locationRepository.listLocations(
        categoryId: locationCategory.id,
        keyword: event.keyword,
      );
      emit(SearchStateSuccess(locations));
    } on Exception catch (error) {
      emit(SearchStateError(error.toString()));
    }
  }
}
