import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trusdkflutter/trusdkflutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('trusdkflutter');

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
    expect(await Trusdkflutter.platformVersion, '42');
  });
}
