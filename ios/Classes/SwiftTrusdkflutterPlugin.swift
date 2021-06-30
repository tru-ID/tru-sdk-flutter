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

public class SwiftTrusdkflutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "id.tru.sdk/flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftTrusdkflutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //This method is called on the Main Thread
      print("gandle called")
        switch call.method {
        case "getPlatformVersion" : result("iOS " + UIDevice.current.systemVersion)
        case "check" : check(arguments: call.arguments, result: result)
        case "checkWithTrace": checkWithTrace(arguments: call.arguments, result: result)
        case "isReachable": isReachable(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
        result("Method was executed successfully")
    }
    
    func check(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No url parameter",
                                details: nil))
            return
        }
        print("check called")
        let sdk = TruSDK()
        sdk.check(url: URL(string: args)!) { error in
            if let error = error {
                result("iOS check() - Error [\(error)]")
            } else {
                result("iOS check() - Success [\(args)]")
            }
        }
       
        
    }
    
    func checkWithTrace(arguments: Any?, result: @escaping FlutterResult) {
        print("checkwithTrace called")
        guard let args = arguments as? String else {
            result(FlutterError(code: "iOSError",
                                message: "No url parameter",
                                details: nil))
            return
        }
        // trusdk.checkwithTrace(url: url) {
        // result(..)
        //}
    }
    
    func isReachable(result: @escaping FlutterResult) {
        print("isRecahale called")
        let sdk = TruSDK()
        sdk.isReachable { reachableResult in
            switch reachableResult {
            case .success(let details): result("iOS isReachable() - Success")
            case .failure(let error): result("iOS isReachable() - \(error)")
            }
            
        }
    }
}

//result(FlutterError(code: "UNAVAILABLE",
//                    message: "Battery info unavailable",
//                    details: nil))


