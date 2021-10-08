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
  static const MethodChannel _channel =
      const MethodChannel('id.tru.sdk/flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String?> check(String url) async {
    try {
      return await _channel.invokeMethod('check', url);
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  Future<String?> checkWithTrace(String url) async {
    try {
      return await _channel.invokeMethod('checkWithTrace', url);
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  Future<String?> isReachable() async {
    try {
      return await _channel.invokeMethod('isReachable');
    } on PlatformException catch (e) {
      return e.message;
    }
  }
}

class ReachabilityDetails {
  String countryCode = "";
  String networkId = "";
  String networkName = "";
  List<Product>? products = [];
  ReachabilityError? error;

  ReachabilityDetails(
      {required this.countryCode,
      required this.networkId,
      required this.networkName,
      required this.products,
      required this.error});

  factory ReachabilityDetails.fromJson(Map<String?, dynamic> jsonBody) {
    var productsJson = jsonBody['products'];

    Iterable l = jsonBody['products'];
    List<Product> products = List<Product>.from(
        l.map((productsJson) => Product.fromJson(productsJson)));

    return ReachabilityDetails(
        countryCode: jsonBody['country_code'],
        networkId: jsonBody['network_id'],
        networkName: jsonBody['network_name'],
        products: products,
        error: jsonBody['error']);
  }
}

class Product {
  String productId = "";
  String productName = "";

  Product({required this.productId, required this.productName});

  factory Product.fromJson(Map<String?, dynamic> json) {
    return Product(
        productId: json['product_id'], productName: json['product_name']);
  }
}

class ReachabilityError {
  String? type;
  String? title;
  int? status;
  String? detail;

  ReachabilityError({this.type, this.title, this.status, this.detail});

  factory ReachabilityError.fromJson(Map<String?, dynamic> json) {
    return ReachabilityError(
        type: json['type'],
        title: json['title'],
        status: json['status'],
        detail: json['detail']);
  }
}

class TraceInfo {
  String trace = "";
  DebugInfo debugInfo = DebugInfo();
}

class DebugInfo {
  Map<String, String> bufferMap = {};
}

class TraceCollector {
  String trace = "";
  bool isTraceEnabled = false;
  DebugInfo debugInfo = DebugInfo();
  bool isDebugInfoCollectionEnabled = false;
  bool isConsoleLogsEnabled = false;
  TraceInfo traceInfo = TraceInfo();
}
