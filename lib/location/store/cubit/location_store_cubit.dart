import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ones_blog/data/models/city.dart';
import 'package:ones_blog/data/models/city_area.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/city_area_repository.dart';
import 'package:ones_blog/domain/city_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

part 'location_store_state.dart';

class LocationStoreCubit extends Cubit<LocationStoreState> {
  LocationStoreCubit({
    required this.userRepository,
    required this.cityRepository,
    required this.cityAreaRepository,
    required this.locationRepository,
    Location? location,
  }) : super(LocationStoreState(location: location));

  final UserRepository userRepository;
  final CityRepository cityRepository;
  final CityAreaRepository cityAreaRepository;
  final LocationRepository locationRepository;

  Future<void> init() async {
    emit(state.copyWith(initStatus: BlocCubitStatus.loading));

    try {
      final cities = await cityRepository.listCities();
      int? cityAreaId, cityId;
      List<CityArea>? cityAreas = [];
      if (state.location != null) {
        final cityArea = await cityAreaRepository.getCityArea(
          state.location!.cityAreaId,
        );
        cityAreaId = cityArea?.id ?? state.cityAreaId;
        if (cityArea != null && cityArea.city != null) {
          cityId = cityArea.city!.id;
          cityAreas = await cityRepository.getCityAreas(cityId);
        }
      }
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.success,
          cities: cities,
          cityId: cityId,
          cityAreaId: cityAreaId,
          cityAreas: cityAreas,
        ),
      );
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  void selectLocationCategory(LocationCategory locationCategory) =>
      emit(state.copyWith(locationCategory: locationCategory));

  Future<void> selectCity(int cityId) async {
    selectCityArea(-1);

    emit(
      state.copyWith(
        initStatus: BlocCubitStatus.loading,
        cityId: cityId,
      ),
    );

    try {
      final cityAreas = await cityRepository.getCityAreas(cityId);
      emit(
        state.copyWith(
          initStatus: BlocCubitStatus.success,
          cityAreas: cityAreas,
        ),
      );
    } on Exception {
      emit(state.copyWith(initStatus: BlocCubitStatus.failure));
    }
  }

  void selectCityArea(int cityAreaId) =>
      emit(state.copyWith(cityAreaId: cityAreaId));

  void imagesPicked(List<XFile> images) {
    emit(
      state.copyWith(
        images: images.map((image) => image.path).toList(),
      ),
    );
  }

  Future<void> submit({
    required String name,
    required String address,
    required String phone,
    String? introduction,
  }) async {
    emit(state.copyWith(status: BlocCubitStatus.loading));
    try {
      await locationRepository.store(
        id: state.location?.id,
        token: userRepository.getToken(),
        categoryId: state.locationCategory.id,
        cityAreaId: state.cityAreaId!,
        name: name,
        address: address,
        phone: phone,
        introduction: introduction,
        images: (state.images ?? []).isNotEmpty ? state.images : null,
      );

      await userRepository.getAuthUser();

      emit(state.copyWith(status: BlocCubitStatus.success));
    } on Exception {
      emit(state.copyWith(status: BlocCubitStatus.failure));
    }
  }
}
