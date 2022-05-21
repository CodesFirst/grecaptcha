import 'package:flutter_test/flutter_test.dart';
import 'package:grecaptcha/grecaptcha.dart';
import 'package:grecaptcha/grecaptcha_platform_interface.dart';
import 'package:grecaptcha/grecaptcha_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGrecaptchaPlatform
    with MockPlatformInterfaceMixin
    implements GrecaptchaPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  // TODO: implement isAvailable
  Future<bool> get isAvailable => throw UnimplementedError();

  @override
  Future<String> verifyWithRecaptcha(String siteKey) {
    // TODO: implement verifyWithRecaptcha
    throw UnimplementedError();
  }
}

void main() {
  final GrecaptchaPlatform initialPlatform = GrecaptchaPlatform.instance;

  test('$MethodChannelGrecaptcha is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGrecaptcha>());
  });

  test('getPlatformVersion', () async {
    Grecaptcha grecaptchaPlugin = Grecaptcha();
    MockGrecaptchaPlatform fakePlatform = MockGrecaptchaPlatform();
    GrecaptchaPlatform.instance = fakePlatform;

    expect(await grecaptchaPlugin.getPlatformVersion(), '42');
  });
}
