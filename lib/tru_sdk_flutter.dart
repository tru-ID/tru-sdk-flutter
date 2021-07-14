/*
 * MIT License
 * Copyright (C) 2020 4Auth Limited. All rights reserved
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:async';
import 'package:flutter/services.dart';

class TruSdkFlutter {
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

