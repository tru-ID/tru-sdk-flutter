#import "TrusdkflutterPlugin.h"
#if __has_include(<trusdkflutter/trusdkflutter-Swift.h>)
#import <trusdkflutter/trusdkflutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "trusdkflutter-Swift.h"
#endif

@implementation TrusdkflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTrusdkflutterPlugin registerWithRegistrar:registrar];
}
@end
