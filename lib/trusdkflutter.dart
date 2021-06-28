
import 'dart:async';

import 'package:flutter/services.dart';

class Trusdkflutter {
  static const MethodChannel _channel =
      const MethodChannel('trusdkflutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
