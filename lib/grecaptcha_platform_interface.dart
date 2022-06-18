import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'grecaptcha_method_channel.dart';

abstract class GrecaptchaPlatform extends PlatformInterface {
  /// Constructs a GrecaptchaPlatform.
  GrecaptchaPlatform() : super(token: _token);

  static final Object _token = Object();

  static GrecaptchaPlatform _instance = MethodChannelGrecaptcha();

  /// The default instance of [GrecaptchaPlatform] to use.
  ///
  /// Defaults to [MethodChannelGrecaptcha].
  static GrecaptchaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GrecaptchaPlatform] when
  /// they register themselves.
  static set instance(GrecaptchaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> get isAvailable {
    throw UnimplementedError('isAvailable has not been implemented.');
  }

  Future<String> verifyWithRecaptcha(String siteKey) {
    throw UnimplementedError('verifyWithRecaptcha() has not been implemented.');
  }

  Future<GooglePlayServicesAvailability?> googlePlayServicesAvailability() {
    throw UnimplementedError('googlePlayServicesAvailability() has not been implemented.');
  }
}

enum GooglePlayServicesAvailability {
  success,
  serviceMissing,
  serviceUpdating,
  serviceVersionUpdateRequired,
  serviceDisabled,
  serviceInvalid
}
