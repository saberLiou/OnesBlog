// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:ones_blog/app/app.dart';
import 'package:ones_blog/bootstrap.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';
import 'package:ones_blog/domain/city_area_repository.dart';
import 'package:ones_blog/domain/city_repository.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/location_score_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';
import 'package:ones_blog/domain/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onesBlogApiClient = OnesBlogApiClient();
  final userRepository = UserRepository(
    onesBlogApiClient: onesBlogApiClient,
    sharedPreferences: await SharedPreferences.getInstance(),
  );
  final locationRepository = LocationRepository(
    onesBlogApiClient: onesBlogApiClient,
  );
  final locationScoreRepository = LocationScoreRepository(
    onesBlogApiClient: onesBlogApiClient,
  );
  final postRepository = PostRepository(onesBlogApiClient: onesBlogApiClient);
  final cityRepository = CityRepository(onesBlogApiClient: onesBlogApiClient);
  final cityAreaRepository = CityAreaRepository(
    onesBlogApiClient: onesBlogApiClient,
  );

  bootstrap(
    () => App(
      userRepository: userRepository,
      locationRepository: locationRepository,
      locationScoreRepository: locationScoreRepository,
      postRepository: postRepository,
      cityRepository: cityRepository,
      cityAreaRepository: cityAreaRepository,
    ),
  );
}
