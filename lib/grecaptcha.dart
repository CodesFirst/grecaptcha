import 'grecaptcha_platform_interface.dart';

class Grecaptcha {
  Future<String?> getPlatformVersion() {
    return GrecaptchaPlatform.instance.getPlatformVersion();
  }

  Future<bool> get isAvailable {
    return GrecaptchaPlatform.instance.isAvailable;
  }

  Future<String> verifyWithRecaptcha(String siteKey) {
    return GrecaptchaPlatform.instance.verifyWithRecaptcha(siteKey);
  }
}
