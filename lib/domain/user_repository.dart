import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/data/models/user.dart';
import 'package:ones_blog/data/ones_blog_api_client.dart';
import 'package:ones_blog/utils/enums/user_login_type.dart';
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

  /// Get the string value by cache key from [SharedPreferences].
  String? _getCacheString(String key) => sharedPreferences.getString(key);

  /// Set the string value by cache key from [SharedPreferences],
  /// or remove the value by passing the empty value.
  Future<void> _setCacheString(
    String key,
    String? value, {
    String? emptyValue = '',
  }) =>
      value != emptyValue
          ? sharedPreferences.setString(key, value!)
          : sharedPreferences.remove(key);

  /// Get the token of the user from [SharedPreferences].
  String? getToken() => _getCacheString('token');

  /// Set the token of the user from [SharedPreferences],
  /// or remove the token by passing null.
  Future<void> setToken(String? token) => _setCacheString(
        'token',
        token,
        emptyValue: null,
      );

  /// Get the email of the user from [SharedPreferences],
  /// during registering flow.
  String getEmail() => _getCacheString('email') ?? '';

  /// Set the email of the user from [SharedPreferences],
  /// or remove the email by passing an empty string,
  /// during registering flow.
  Future<void> setEmail(String email) => _setCacheString('email', email);

  /// Get the email of the user from [SharedPreferences],
  /// during forgetting-password flow.
  String getForgetEmail() => _getCacheString('forget_email') ?? '';

  /// Set the email of the user from [SharedPreferences],
  /// or remove the email by passing an empty string,
  /// during forgetting-password flow.
  Future<void> setForgetEmail(String email) => _setCacheString(
        'forget_email',
        email,
      );

  /// Get the verification code of the user from [SharedPreferences],
  /// during forgetting-password flow.
  String getForgetCode() => sharedPreferences.getString('forget_code') ?? '';

  /// Set the verification code of the user from [SharedPreferences],
  /// or remove the verification code by passing empty string,
  /// during forgetting-password flow.
  Future<void> setForgetCode(String code) => _setCacheString(
        'forget_code',
        code,
      );

  /// Get the user from [SharedPreferences].
  User? getUser() {
    final userJson = sharedPreferences.getString('user');
    return (userJson != null)
        ? User.fromJson(jsonDecode(userJson) as Map<String, dynamic>)
        : null;
  }

  /// Set the user from [SharedPreferences],
  /// or remove the user by passing null.
  Future<void> setUser(User? user) => user != null
      ? sharedPreferences.setString('user', jsonEncode(user.toJson()))
      : sharedPreferences.remove('user');

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

      final user = User.fromJson(
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

      await setEmail(user.email);

      return user;
    } on Exception {
      throw UserException();
    }
  }

  /// Send verification code for a registering,
  /// or registered user but forgot password.
  ///
  /// Throws a [UserException] if an error occurs.
  Future<void> sendVerificationCode({
    required bool registerFlow,
    required String email,
  }) async {
    try {
      await _onesBlogApiClient.store(
        uri: registerFlow ? 'resend-verification-code' : 'forgot-password',
        inputParams: {
          'email': email,
        },
      );
    } on Exception {
      throw UserException();
    }
  }

  /// Verify code for a registering user,
  /// or registered user but forgot password.
  ///
  /// Throws a [UserException] if an error occurs.
  Future<void> verifyCode({
    required bool registerFlow,
    required String email,
    required String code,
  }) async {
    try {
      await _onesBlogApiClient.store(
        uri: registerFlow ? 'verify-code' : 'check-code',
        inputParams: {
          'email': email,
          'code': code,
        },
      );
      if (registerFlow) {
        await setEmail('');
      } else {
        await setForgetEmail(email);
        await setForgetCode(code);
      }
    } on Exception {
      throw UserException();
    }
  }

  /// Reset password for the verified user from [SharedPreferences].
  ///
  /// Throws a [UserException] if an error occurs.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      await _onesBlogApiClient.store(
        uri: 'reset-password',
        inputParams: {
          'email': email,
          'code': code,
          'password': password,
        },
      );
      await setForgetEmail('');
      await setForgetCode('');
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
      await setUser(user);

      return user;
    } on Exception {
      throw UserException();
    }
  }

  /// Get and reset the user from [SharedPreferences].
  ///
  /// Throws a [UserException] if an error occurs.
  Future<User?> getAuthUser() async {
    try {
      var localUser = getUser();
      if (localUser != null) {
        await setUser(
          User.fromJson(
            await _onesBlogApiClient.get(
              uri: 'users/${localUser.id}',
              token: getToken(),
            ) as Map<String, dynamic>,
          ),
        );
        localUser = getUser();
      }
      return localUser;
    } on Exception {
      throw UserException();
    }
  }

  /// Update the user.
  ///
  /// Throws a [UserException] if an error occurs.
  Future<User> update({
    String? username,
    String? password,
    UserLoginType? loginType,
  }) async {
    try {
      final user = User.fromJson(
        await _onesBlogApiClient.update(
          uri: 'users/${getUser()!.id}',
          inputParams: {
            if (username != null) ...{
              'name': username,
            },
            if (password != null) ...{
              'password': password,
            },
            if (loginType != null) ...{
              'login_type_id': loginType.id.toString(),
            }
          },
          token: getToken(),
        ) as Map<String, dynamic>,
      );
      await setUser(user);
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
      await setUser(null);
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
