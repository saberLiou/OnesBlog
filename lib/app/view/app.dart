// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ones_blog/domain/city_area_repository.dart';
import 'package:ones_blog/domain/city_repository.dart';
import 'package:ones_blog/domain/location_like_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/location_score_repository.dart';
import 'package:ones_blog/domain/post_keep_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:ones_blog/home/home.dart';
import 'package:ones_blog/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.userRepository,
    required this.locationRepository,
    required this.locationScoreRepository,
    required this.locationLikeRepository,
    required this.postRepository,
    required this.postKeepRepository,
    required this.cityRepository,
    required this.cityAreaRepository,
  });

  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final LocationScoreRepository locationScoreRepository;
  final LocationLikeRepository locationLikeRepository;
  final PostRepository postRepository;
  final PostKeepRepository postKeepRepository;
  final CityRepository cityRepository;
  final CityAreaRepository cityAreaRepository;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: locationRepository),
          RepositoryProvider.value(value: locationScoreRepository),
          RepositoryProvider.value(value: locationLikeRepository),
          RepositoryProvider.value(value: postRepository),
          RepositoryProvider.value(value: postKeepRepository),
          RepositoryProvider.value(value: cityRepository),
          RepositoryProvider.value(value: cityAreaRepository),
        ],
        child: const AppView(),
      );
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance.userInteractions = false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
