// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:ones_blog/app/app.dart';
import 'package:ones_blog/bootstrap.dart';
import 'package:ones_blog/domain/location_repository.dart';
import 'package:ones_blog/domain/post_repository.dart';

void main() {
  final locationRepository = LocationRepository();
  final postRepository = PostRepository();

  bootstrap(
    () => App(
      locationRepository: locationRepository,
      postRepository: postRepository,
    ),
  );
}
