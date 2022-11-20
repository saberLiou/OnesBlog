import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_carousel_slider_state.dart';

class ImageCarouselSliderCubit extends Cubit<ImageCarouselSliderState> {
  ImageCarouselSliderCubit() : super(const ImageCarouselSliderState());

  void setPage(int page) => emit(state.copyWith(currentPage: page));
}