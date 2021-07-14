#import "TruSdkFlutterPlugin.h"
#if __has_include(<tru_sdk_flutter/tru_sdk_flutter-Swift.h>)
#import <tru_sdk_flutter/tru_sdk_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tru_sdk_flutter-Swift.h"
#endif

@implementation TruSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTruSdkFlutterPlugin registerWithRegistrar:registrar];
}
@end
