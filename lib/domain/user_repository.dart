import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thrown when an error occurs while manipulating the user.
class UserException implements Exception {}

/// {@template location_repository}
/// A Dart Repository of the User domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    OnesBlogApiClient? onesBlogApiClient,
    required this.sharedPreferences,
  }) : _onesBlogApiClient = onesBlogApiClient ?? OnesBlogApiClient();

  final OnesBlogApiClient _onesBlogApiClient;
  final SharedPreferences sharedPreferences;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  /// Get the token of the user from [SharedPreferences].
  String? getToken() => sharedPreferences.getString('token');

  /// Set the token of the user from [SharedPreferences],
  /// or remove the token by passing null.
  Future<void> setToken(String? token) => token != null
      ? sharedPreferences.setString('token', token)
      : sharedPreferences.remove('token');

  /// Register the user.
  ///
  /// Throws a [UserException] if an error occurs.
  Future<User> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final deviceName = await _getDeviceName();

      return User.fromJson(
        await _onesBlogApiClient.store(
          uri: 'register',
          inputParams: {
            'email': email,
            'name': username,
            'password': password,
            'device_name': deviceName,
          },
        ) as Map<String, dynamic>,
      );
    } on Exception {
      throw UserException();
    }
  }

  Future<User> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      return User.fromJson(
        await _onesBlogApiClient.store(
          uri: 'verifyCode',
          inputParams: {
            'email': email,
            'code': code,
          },
        ) as Map<String, dynamic>,
      );
    } on Exception {
      throw UserException();
    }
  }

  /// Login the user.
  ///
  /// Throws a [UserException] if an error occurs.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final deviceName = await _getDeviceName();

      final user = User.fromJson(
        await _onesBlogApiClient.store(
          uri: 'login',
          inputParams: {
            'email': email,
            'password': password,
            'device_name': deviceName,
          },
        ) as Map<String, dynamic>,
      );

      await setToken(user.token);

      return user;
    } on Exception {
      throw UserException();
    }
  }

  /// Logout the user.
  ///
  /// Throws a [UserException] if an error occurs.
  Future<User> logout() async {
    try {
      final deviceName = await _getDeviceName();

      return User.fromJson(
        await _onesBlogApiClient.store(
          uri: 'logout',
          inputParams: {
            'device_name': deviceName,
          },
          token: getToken(),
        ) as Map<String, dynamic>,
      );
    } on Exception {
      throw UserException();
    } finally {
      await setToken(null);
    }
  }

  /// Get the device name.
  ///
  /// Throws a [PlatformException] if an error occurs.
  Future<String?> _getDeviceName() async {
    try {
      if (kIsWeb) {
        return (await deviceInfoPlugin.webBrowserInfo).userAgent;
      } else {
        if (Platform.isAndroid) {
          return (await deviceInfoPlugin.androidInfo).device;
        } else if (Platform.isIOS) {
          return (await deviceInfoPlugin.iosInfo).name;
        } else if (Platform.isLinux) {
          return (await deviceInfoPlugin.linuxInfo).name;
        } else if (Platform.isMacOS) {
          return (await deviceInfoPlugin.macOsInfo).computerName;
        } else if (Platform.isWindows) {
          return (await deviceInfoPlugin.windowsInfo).computerName;
        }
      }
      return null;
    } on PlatformException {
      return null;
    }
  }
}