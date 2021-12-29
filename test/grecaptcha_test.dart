import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grecaptcha/grecaptcha.dart';

void main() {
  const MethodChannel channel = MethodChannel('grecaptcha');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Grecaptcha.platformVersion, '42');
  });
}
