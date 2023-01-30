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
import Flutter
import UIKit
import tru_sdk_ios

public class SwiftTruSdkFlutterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "id.tru.sdk/flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftTruSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //This method is called on the Main Thread
        switch call.method {
        case "getPlatformVersion" : result("iOS " + UIDevice.current.systemVersion)
        case "openWithDataCellular" : openWithDataCellular(arguments: call.arguments, result: result)
        case "openWithDataCellularAndAccessToken" : openWithDataCellularAndAccessToken(arguments: call.arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func openWithDataCellular(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? Dictionary<String, Any> else {
            result(FlutterError(code: "iOSError",
                                message: "Invalid parameters",
                                details: nil))
            return
        }
        guard let urlString = args["url"] as? String, let url = URL(string: urlString) else {
            result(FlutterError(code: "iOSError",
                                message: "No url parameter",
                                details: nil))
            return
        }
        guard let debug = args["debug"] as? Bool else {
            result(FlutterError(code: "iOSError",
                                message: "No debug parameter",
                                details: nil))
            return
        }
        let sdk = TruSDK()
        sdk.openWithDataCellular(url:  url, debug: debug) { resp in
            result(resp)
        }
    }

    func openWithDataCellularAndAccessToken(arguments: Any?, result: @escaping FlutterResult) {
            guard let args = arguments as? Dictionary<String, Any> else {
                result(FlutterError(code: "iOSError",
                                    message: "Invalid parameters",
                                    details: nil))
                return
            }
            guard let urlString = args["url"] as? String, let url = URL(string: urlString) else {
                result(FlutterError(code: "iOSError",
                                    message: "No url parameter",
                                    details: nil))
                return
            }
            guard let debug = args["debug"] as? Bool else {
                result(FlutterError(code: "iOSError",
                                    message: "No debug parameter",
                                    details: nil))
                return
            }
            guard let accessToken = args["accessToken"] as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No accessToken parameter",
                                details: nil))
            return
        }
            let sdk = TruSDK()
        sdk.openWithDataCellularAndAccessToken(url:  url, accessToken: accessToken, debug: debug) { resp in
                result(resp)
            }
        }



}

