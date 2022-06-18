import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'grecaptcha_platform_interface.dart';
import 'recaptcha_not_available_exception.dart';

/// An implementation of [GrecaptchaPlatform] that uses method channels.
class MethodChannelGrecaptcha extends GrecaptchaPlatform {
  bool _checkedAvailability = false;
  bool _isAvailable = false;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('grecaptcha');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Returns true when the API is available, which should be the case if the
  /// app is running on Android. The plugin will throw an exception when used
  /// on platforms where it's not available.
  @override
  Future<bool> get isAvailable async {
    if (_checkedAvailability) {
      return _isAvailable;
    }

    var awailable = await methodChannel.invokeMethod("isSupported");
    _isAvailable = awailable;
    _checkedAvailability = true;

    return _isAvailable;
  }

  /// Verifies that the user is human and returns a token that your backend
  /// server can verify by making a call to the [reCaptcha API](https://developers.google.com/recaptcha/docs/verify).
  @override
  Future<String> verifyWithRecaptcha(String siteKey) async {
    if (!await isAvailable) {
      throw const ReCaptchaNotAvailableException();
    }

    return await methodChannel.invokeMethod("verify", {"key": siteKey});
  }

  //Check if you have the google play service enabled
  @override
  Future<GooglePlayServicesAvailability?> googlePlayServicesAvailability() async {
    final String result = await methodChannel.invokeMethod('checkGooglePlayServicesAvailability');

    switch (result) {
      case 'success':
        return GooglePlayServicesAvailability.success;
      case 'service_missing':
        return GooglePlayServicesAvailability.serviceMissing;
      case 'service_updating':
        return GooglePlayServicesAvailability.serviceUpdating;
      case 'service_version_update_required':
        return GooglePlayServicesAvailability.serviceVersionUpdateRequired;
      case 'service_disabled':
        return GooglePlayServicesAvailability.serviceDisabled;
      case 'service_invalid':
        return GooglePlayServicesAvailability.serviceInvalid;
    }

    return null;
  }
}
