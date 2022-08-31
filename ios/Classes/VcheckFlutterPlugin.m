#import "VcheckFlutterPlugin.h"
#if __has_include(<vcheck_flutter/vcheck_flutter-Swift.h>)
#import <vcheck_flutter/vcheck_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vcheck_flutter-Swift.h"
#endif

@implementation VcheckFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVcheckFlutterPlugin registerWithRegistrar:registrar];
}
@end
