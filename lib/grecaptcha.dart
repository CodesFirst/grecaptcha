
import 'dart:async';

import 'package:flutter/services.dart';

class Grecaptcha {
  static const MethodChannel _channel = MethodChannel('grecaptcha');
  static bool _checkedAvailability = false;
  static bool _isAvailable = false;

  /// Returns true when the API is available, which should be the case if the
  /// app is running on Android. The plugin will throw an exception when used
  /// on platforms where it's not available.
  static Future<bool> get isAvailable async {
    if (_checkedAvailability) {
      return _isAvailable;
    }

    var awailable = await _channel.invokeMethod("isSupported");
    _isAvailable = awailable;
    _checkedAvailability = true;

    return _isAvailable;
  }

  /// Verifies that the user is human and returns a token that your backend
  /// server can verify by making a call to the [reCaptcha API](https://developers.google.com/recaptcha/docs/verify).
  static Future<String> verifyWithRecaptcha(String siteKey) async {
    if (!await isAvailable) {
      throw const ReCaptchaNotAvailableException();
    }

    return await _channel.invokeMethod("verify", {"key": siteKey});
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class ReCaptchaNotAvailableException implements Exception {
  const ReCaptchaNotAvailableException();
}