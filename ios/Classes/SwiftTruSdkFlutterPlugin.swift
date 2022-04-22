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
        case "check" : check(arguments: call.arguments, result: result)
        case "checkUrlWithResponseBody" : checkUrlWithResponseBody(arguments: call.arguments, result: result)
        case "checkWithTrace": checkWithTrace(arguments: call.arguments, result: result)
        case "isReachable": isReachable(result: result)
        case "isReachableWithDataResidency": isReachableWithDataResidency(arguments: call.arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func check(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No url parameter",
                                details: nil))
            return
        }

        let sdk = TruSDK()
        sdk.check(url: URL(string: args)!) { error in
            if let error = error {
                result("iOS check() - Error [\(error)]")
            } else {
                result("iOS check() - Success [\(args)]")
            }
        }
    }

    func checkUrlWithResponseBody(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No url parameter",
                                details: nil))
            return
        }

        let sdk = TruSDK()
        sdk.checkUrlWithResponseBody(url: URL(string: args)!) { error, body in
            if let error = error {
                result(FlutterError(code: "iOSError",
                                    message: error.localizedDescription,
                                    details: error))
            } else {
                if let body = body {
                    if body["code"] != nil && body["check_id"] != nil {
                        //return a dictionary with the successful response
                        let success = [
                            "code": body["code"],
                            "check_id": body["check_id"],
                            "reference_id": body["reference_id"]
                        ]
                        result(success)
                    } else if body["error"] != nil && body["error_description"] != nil {
                        //return a dictionary with the error response
                        let failure = [
                            "error":body["error"],
                            "error_description":body["error_description"],
                            "check_id": body["check_id"],
                            "reference_id": body["reference_id"]  
                        ]
                        result(failure)
                    } else {
                        result(FlutterError(code: "iOSError",
                                            message: "There is an issue with response body. Unable to serialise success or error from the dictionary",
                                            details: error))
                    }
                } else {
                    result(nil) //Since v0.1 does not return a body, we are returning nil
                }
            }
        }
    }

    func checkWithTrace(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No url parameter",
                                details: nil))
            return
        }

        let sdk = TruSDK()
        sdk.checkWithTrace(url: URL(string: args)!) { error, traceInfo in
            if let error = error {
                result(FlutterError(code: "iOSError",
                                    message: error.localizedDescription,
                                    details: error))
            } else {
                if let body = traceInfo?.responseBody {
                    if body["code"] != nil && body["check_id"] != nil {
                        //return a dictionary with the successful response
                        let success = [
                            "code": body["code"],
                            "check_id": body["check_id"],
                            "reference_id": body["reference_id"],
                            "trace": traceInfo?.trace
                        ]
                        result(success)
                        print("Plugin", "checkWithTrace Success")
                    } else if body["error"] != nil && body["error_description"] != nil {
                        //return a dictionary with the error response
                        let failure = [
                            "error":body["error"],
                            "error_description":body["error_description"],
                            "check_id": body["check_id"],
                            "reference_id": body["reference_id"],
                            "trace": traceInfo?.trace
                        ]
                        result(failure)
                        print("Plugin", "checkWithTrace Failure")
                    } else {
                        result(FlutterError(code: "iOSError",
                                            message: "There is an issue with response body. Unable to serialise success or error from the dictionary",
                                            details: error))
                    }
                } else {
                    let responseWithTrace = [
                      "trace": traceInfo?.trace,
                    ]
                    result(responseWithTrace) //Since v0.1 does not return a body, we are returning just the trace
                    print("Plugin", "checkWithTrace Trace")
                }
            }
        }
    }

    // TODO: Return serialised ReachabilityDetails
    func isReachable(result: @escaping FlutterResult) {
        print("isReachable called")
        let sdk = TruSDK()
        sdk.isReachable { reachableResult in
            switch reachableResult {
            case .success(let details):
                do {
                    let jsonData = try JSONEncoder().encode(details)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                     result(jsonString)
                } catch  {
                    result("Unable to decode reachability result")
                }
            case .failure(let error): result("iOS isReachable() - \(error)")
            }
        }
    }

    func isReachableWithDataResidency(arguments: Any?, result: @escaping FlutterResult) {
        guard let dataResidency = arguments as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No dataResidency parameter",
                                details: nil))
            return
        }
        print("isReachableWithDataResidency called")
        let sdk = TruSDK()
        
        sdk.isReachable(dataResidency: dataResidency) { reachableResult in
                    switch reachableResult {
                    case .success(let details):
                        do {
                            let jsonData = try JSONEncoder().encode(details)
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                             result(jsonString)
                        } catch  {
                            result("Unable to decode reachability result")
                        }
                    case .failure(let error): result("iOS isReachable() - \(error)")
                    }
                }
            }

}

//result(FlutterError(code: "UNAVAILABLE",
//                    message: "Battery info unavailable",
//
