
import 'dart:async';
import 'package:flutter/services.dart';

class Trusdkflutter {

  static const MethodChannel _channel = const MethodChannel('id.tru.sdk/flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String?> check(String url) async {
    String? sdkCheck;
    try {
      sdkCheck = await _channel.invokeMethod('check', url);
    } on PlatformException catch (e) {
      sdkCheck = "Failed to get result: '${e.message}'.";
    }
    print("check called");
    return sdkCheck;
  }

  Future<String?> checkWithTrace(String url) async {
    String? sdkCheckWithTrace;
    try {
      sdkCheckWithTrace = await _channel.invokeMethod('checkWithTrace', url);
    } on PlatformException catch (e) {
      null;
    }
    print("checkwithTrace called");
  }

  Future<String?> isReachable() async {
    String? sdkIsReachable;
    try {
      sdkIsReachable = await _channel.invokeMethod('isReachable');
    } on PlatformException catch (e) {
      null;
    }
    print("reachability called");
  }

}

class ReachabilityDetails {
  String countryCode = "";
  String networkId = "";
  String networkName = "";
  List<Product>? products = [];
  String link = "";
}

class Product {
  String productId = "";
  ProductType productType = ProductType.PhoneCheck;
}

enum ProductType {
  PhoneCheck,
  SIMCheck ,
  SubscriberCheck,
}

class ReachabilityError {
  String type = "";
  String title = "";
  int status = 0;
  String detail = "";
}

class TraceInfo {
  String trace = "";
  DebugInfo debugInfo = DebugInfo();
}

class DebugInfo {
  Map<String,String> bufferMap = {};
}

class TraceCollector {
  String trace = "";
  bool isTraceEnabled = false;
  DebugInfo debugInfo = DebugInfo();
  bool isDebugInfoCollectionEnabled = false;
  bool isConsoleLogsEnabled = false;
  TraceInfo traceInfo = TraceInfo();
}
