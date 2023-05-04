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

  Future<Map> openWithDataCellular(String url, bool debug) async {
    try {
      return await _channel
          .invokeMethod('openWithDataCellular', {'url': url, 'debug': debug});
    } on PlatformException catch (e) {
      return {'error': 'sdk_error', 'error_description': e.message};
    }
  }

  Future<Map> openWithDataCellularAndAccessToken(String url, String? accessToken, bool debug) async {
    try {
      return await _channel
          .invokeMethod('openWithDataCellularAndAccessToken', {'url': url, 'accessToken': accessToken,'debug': debug});
    } on PlatformException catch (e) {
      return {'error': 'sdk_error', 'error_description': e.message};
    }
  }
}

class Coverage {
  final String country;
  final String networkId;
  final String networkName;
  final String mobileDataIp;
  final List<Product>? products;
  Coverage(
      {required this.country,
      required this.networkId,
      required this.networkName,
      required this.mobileDataIp,
      required this.products});

  factory Coverage.fromJson(Map<dynamic, dynamic> json) {
    List<Product> products = <Product>[];
    if (json['products'] != null) {
      json['products'].forEach((item) {
        products.add(Product.fromJson(item));
      });
    }
    return Coverage(
        country: json['country_code'],
        networkId: json['network_id'],
        networkName: json['network_name'],
        mobileDataIp:json['mobile_data_ip'],
        products: products);
  }
}



class Product {
  final String id;
  final String name;
  Product({required this.id, required this.name});

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
    );
  }

  @override
  String toString() {
    return id + " - " + name;
  }
}

class CheckSuccessBody {
  final String code;
  final String checkId;
  final String? referenceId;

  CheckSuccessBody(
      {required this.code, required this.checkId, required this.referenceId});

  factory CheckSuccessBody.fromJson(Map<dynamic, dynamic> json) {
    return CheckSuccessBody(
      code: json['code'],
      checkId: json['check_id'],
      referenceId: json['reference_id'],
    );
  }

  @override
  String toString() {
    return code + " - " + checkId;
  }
}

class CheckErrorBody {
  final String error;
  final String description;
  final String checkId;
  final String? referenceId;

  CheckErrorBody(
      {required this.error,
      required this.description,
      required this.checkId,
      required this.referenceId});

  factory CheckErrorBody.fromJson(Map<dynamic, dynamic> json) {
    return CheckErrorBody(
      error: json['error'],
      description: json['error_description'],
      checkId: json['check_id'],
      referenceId: json['reference_id'],
    );
  }

  @override
  String toString() {
    return error + " - " + description;
  }
}

class ApiError {
  final int status;
  final String type;
  final String title;
  final String detail;
  ApiError(
    {required this.status,
    required this.type,
    required this.title,
    required this. detail});
  factory ApiError.fromJson(Map<dynamic, dynamic> json) {
    return ApiError(
      status: json['status'],
      type: json['type'],
      title: json['title'],
      detail: json['detail'],
    );
  }
}
