import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('id.tru.sdk/flutter');

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
    expect(await TruSdkFlutter.platformVersion, '42');
  });
}
