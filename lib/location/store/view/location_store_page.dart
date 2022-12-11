import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ones_blog/app/view/menu_view.dart';
import 'package:ones_blog/app/widgets/app_button.dart';
import 'package:ones_blog/app/widgets/fixed_app_bar.dart';
import 'package:ones_blog/app/widgets/images_picker.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/domain/city_area_repository.dart';
import 'package:ones_blog/domain/city_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/home/view/home_page.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/location/store/location_store.dart';
import 'package:ones_blog/location/widgets/location_category_select.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_duration.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/popped_from_page_arguments.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/bloc_cubit_status.dart';
import 'package:ones_blog/utils/enums/location_category.dart';
import 'package:ones_blog/utils/form_validator.dart';
import 'package:ones_blog/utils/size_handler.dart';

class LocationStorePage extends StatelessWidget {
  const LocationStorePage({super.key});

  static Route<PoppedFromPageArguments> route(Location? location) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<LocationStoreCubit>.value(
          value: LocationStoreCubit(
            cityRepository: context.read<CityRepository>(),
            userRepository: context.read<UserRepository>(),
            locationRepository: context.read<LocationRepository>(),
            cityAreaRepository: context.read<CityAreaRepository>(),
            location: location,
          )..init(),
          child: const LocationStorePage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const LocationStoreView();
}

class LocationStoreView extends StatefulWidget {
  const LocationStoreView({super.key});

  @override
  State createState() => _LocationStoreViewState();
}

List<bool> isPressed = [false, false, false, false, false, false, false];

class _LocationStoreViewState extends State<LocationStoreView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController,
      _addressController,
      _phoneController,
      _introductionController;

  bool twentyFourSeven = false, nonBusinessDays = false;
  TimeOfDay? startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? endTime = const TimeOfDay(hour: 0, minute: 0);

  @override
  void initState() {
    super.initState();
    final location = context.read<LocationStoreCubit>().state.location;
    if (location != null) {
      _nameController = TextEditingController(text: location.name);
      _addressController = TextEditingController(text: location.address);
      _phoneController = TextEditingController(text: location.phone);
      _introductionController = TextEditingController(
        text: location.introduction,
      );
    } else {
      _nameController = TextEditingController();
      _addressController = TextEditingController();
      _phoneController = TextEditingController();
      _introductionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _introductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeHandler.init(context);
    final l10n = context.l10n;
    final locationStoreCubit = context.read<LocationStoreCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: const MenuView(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            const FixedAppBar(),
          ],
          body: BlocConsumer<LocationStoreCubit, LocationStoreState>(
            listener: (context, state) {
              switch (state.status) {
                case BlocCubitStatus.initial:
                  break;
                case BlocCubitStatus.loading:
                  EasyLoading.show(
                    status: l10n.submittingMessage,
                  );
                  break;
                case BlocCubitStatus.success:
                  EasyLoading.showSuccess(
                    state.isEditing
                        ? l10n.submittedSuccessMessage
                        : l10n.becomeLocationSuccessMessage,
                    duration:
                        state.isEditing ? AppDuration.short : AppDuration.long,
                  );
                  if (state.isEditing) {
                    Navigator.pop(
                      context,
                      PoppedFromPageArguments(
                        page: PoppedFromPage.storeLocation,
                        arguments: {
                          'submitted': true,
                        },
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(context, HomePage.route());
                  }
                  break;
                case BlocCubitStatus.failure:
                  EasyLoading.showError(
                    l10n.submittedFailureMessage,
                    duration: AppDuration.short,
                  );
                  break;
              }
            },
            builder: (context, state) => SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      color: AppColors.primary,
                      height: SizeHandler.screenHeight + 600,
                      width: SizeHandler.screenWidth,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: SpaceUnit.doubleBase,
                            ),
                            width: 300,
                            height: 1200,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(SpaceUnit.base),
                              ),
                            ),
                            child: Column(
                              children: [
                                LocationCategorySelect(
                                  onChanged: (value) =>
                                      locationStoreCubit.selectLocationCategory(
                                    value! as LocationCategory,
                                  ),
                                  l10n: l10n,
                                  value: LocationCategory.getById(
                                    state.location?.categoryId,
                                  ),
                                ),
                                Container(
                                  height: SpaceUnit.quarterBase,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  width: 300,
                                  height: 40,
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '店家名稱',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (String? value) =>
                                        (FormValidator(
                                      l10n: l10n,
                                      value: value,
                                    )..validateRequired())
                                            .errorMessage,
                                  ),
                                ),
                                Container(
                                  height: SpaceUnit.quarterBase,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  width: 300,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: DropdownButtonFormField2(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        hintText: '縣市',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: SpaceUnit.base),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (state.location == null)
                                          ? (value) => locationStoreCubit
                                              .selectCity(value! as int)
                                          : null,
                                      value: state.cityId,
                                      items: state.cities
                                          ?.map(
                                            (city) => DropdownMenuItem<int>(
                                              value: city.id,
                                              child: Center(
                                                child: Text(
                                                  city.city,
                                                  style: AppTextStyle.content,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: SpaceUnit.quarterBase,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  width: 300,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: DropdownButtonFormField2(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        hintText: '鄉鎮市區',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: SpaceUnit.base),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (state.location == null)
                                          ? (value) => locationStoreCubit
                                              .selectCityArea(value! as int)
                                          : null,
                                      value: state.cityAreaId,
                                      items: state.cityAreas
                                          ?.map(
                                            (area) => DropdownMenuItem<int>(
                                              value: area.id,
                                              child: Center(
                                                child: Text(
                                                  area.cityArea,
                                                  style: AppTextStyle.content,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: SpaceUnit.quarterBase,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  width: 300,
                                  height: 40,
                                  child: TextFormField(
                                    controller: _addressController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '地址',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (String? value) =>
                                        (FormValidator(
                                      l10n: l10n,
                                      value: value,
                                    )..validateRequired())
                                            .errorMessage,
                                  ),
                                ),
                                Container(
                                  height: SpaceUnit.quarterBase,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  width: 300,
                                  height: 40,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '電話/手機',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (String? value) =>
                                        (FormValidator(
                                      l10n: l10n,
                                      value: value,
                                    )..validateRequired())
                                            .errorMessage,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  height: SpaceUnit.quarterBase,
                                  width: 280,
                                  color: AppColors.primary,
                                ),
                                // TODO: 新增營業時間
                                // Text(
                                //   '選取營業時間',
                                //   style: AppTextStyle.content,
                                // ),
                                // SizedBox(
                                //   height: 10.0,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     buildDateButton(0, '一'),
                                //     buildDateButton(1, '二'),
                                //     buildDateButton(2, '三'),
                                //     buildDateButton(3, '四'),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     buildDateButton(4, '五'),
                                //     buildDateButton(5, '六'),
                                //     buildDateButton(6, '日'),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Column(
                                //       children: [
                                //         Text(
                                //           '開始時間',
                                //           style: TextStyle(
                                //             fontSize: 12,
                                //             color:
                                //                 Color.fromRGBO(241, 208, 10, 1),
                                //           ),
                                //         ),
                                //         Container(
                                //           width: 120,
                                //           height: 50,
                                //           decoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color: Color.fromRGBO(
                                //                     222, 215, 209, 1),
                                //                 width: 2.0),
                                //           ),
                                //           child: Center(
                                //             child: TextButton(
                                //               child: Text(
                                //                 '${startTime!.hour.toString()}:${startTime!.minute.toString()}',
                                //                 style: AppTextStyle.content,
                                //               ),
                                //               onPressed: () async {
                                //                 TimeOfDay? newTime =
                                //                     await showTimePicker(
                                //                   context: context,
                                //                   initialTime: startTime!,
                                //                 );
                                //                 if (newTime != null) {
                                //                   setState(
                                //                     () {
                                //                       startTime = newTime;
                                //                     },
                                //                   );
                                //                 }
                                //               },
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //     Column(
                                //       children: [
                                //         Text(
                                //           '結束時間',
                                //           style: TextStyle(
                                //             fontSize: 12,
                                //             color:
                                //                 Color.fromRGBO(241, 208, 10, 1),
                                //           ),
                                //         ),
                                //         Container(
                                //           width: 120,
                                //           height: 50,
                                //           decoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color: Color.fromRGBO(
                                //                     222, 215, 209, 1),
                                //                 width: 2.0),
                                //           ),
                                //           child: Center(
                                //             child: TextButton(
                                //               child: Text(
                                //                 '${endTime!.hour.toString()}:${endTime!.minute.toString()}',
                                //                 style: AppTextStyle.content,
                                //               ),
                                //               onPressed: () async {
                                //                 TimeOfDay? newTime =
                                //                     await showTimePicker(
                                //                   context: context,
                                //                   initialTime: endTime!,
                                //                 );
                                //                 if (newTime != null) {
                                //                   setState(() {
                                //                     endTime = newTime;
                                //                   });
                                //                 }
                                //               },
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Spacer(),
                                //     TextButton(
                                //       child: Text('新增時間',
                                //           style: AppTextStyle.content),
                                //       onPressed: () {},
                                //     ),
                                //     SizedBox(
                                //       width: 20,
                                //     ),
                                //   ],
                                // ),
                                // Container(
                                //   height: 2.0,
                                //   width: 280,
                                //   color: Color.fromRGBO(222, 215, 209, 1),
                                // ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: 300,
                                  height: 280,
                                  child: TextFormField(
                                    controller: _introductionController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '簡介',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(
                                    bottom: SpaceUnit.base,
                                  ),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                    ),
                                    items: [
                                      for (final image
                                          in state.images ?? <String>[]) ...[
                                        Image.file(
                                          File(image),
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                ImagesPicker(
                                  onPickedFromGallery: () async => ImagePicker()
                                      .pickMultiImage()
                                      .then((images) {
                                    Navigator.pop(context);
                                    if (images.isNotEmpty) {
                                      locationStoreCubit.imagesPicked(images);
                                    }
                                  }),
                                  onPickedFromCamera: () async => ImagePicker()
                                      .pickImage(source: ImageSource.camera)
                                      .then((image) {
                                    Navigator.pop(context);
                                    if (image != null) {
                                      locationStoreCubit.imagesPicked([image]);
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppButton(
                                height: SpaceUnit.base * 7,
                                width: SpaceUnit.base * 11,
                                title: l10n.cancel,
                                onPressed: () => state.isEditing
                                    ? Navigator.pop(
                                        context,
                                        PoppedFromPageArguments(
                                          page: PoppedFromPage.storeLocation,
                                        ),
                                      )
                                    : Navigator.pushReplacement(
                                        context,
                                        HomePage.route(),
                                      ),
                              ),
                              AppButton(
                                height: SpaceUnit.base * 7,
                                width: SpaceUnit.base * 11,
                                title: l10n.submit,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (state.cityAreaId == null) {
                                    EasyLoading.showInfo(
                                      l10n.emptyCityAndAreaMessage,
                                      duration: AppDuration.short,
                                    );
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    locationStoreCubit.submit(
                                      name: _nameController.value.text,
                                      address: _addressController.value.text,
                                      phone: _phoneController.value.text,
                                      introduction:
                                          _introductionController.value.text,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildDateButton(int buttonIndex, String date) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color.fromRGBO(222, 215, 209, 1),
          width: 3.0,
        ),
        color: isPressed[buttonIndex]
            ? Color.fromRGBO(222, 215, 209, 1)
            : Colors.white,
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            isPressed[buttonIndex] = !isPressed[buttonIndex];
          });
          print('press');
        },
        child: Text(date, style: AppTextStyle.content),
      ),
    );
  }
}
