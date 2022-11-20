part of 'image_carousel_slider_cubit.dart';

class ImageCarouselSliderState extends Equatable {
  const ImageCarouselSliderState({
    this.currentPage = 0,
  });

  final int currentPage;

  ImageCarouselSliderState copyWith({
    int? currentPage,
  }) =>
      ImageCarouselSliderState(
        currentPage: currentPage ?? this.currentPage,
      );

  @override
  List<Object?> get props => [currentPage];
}
