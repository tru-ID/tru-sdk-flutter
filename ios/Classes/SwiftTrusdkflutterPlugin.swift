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


