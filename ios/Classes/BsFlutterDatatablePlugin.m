#import "BsFlutterDatatablePlugin.h"
#if __has_include(<bs_flutter_datatable/bs_flutter_datatable-Swift.h>)
#import <bs_flutter_datatable/bs_flutter_datatable-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bs_flutter_datatable-Swift.h"
#endif

@implementation BsFlutterDatatablePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBsFlutterDatatablePlugin registerWithRegistrar:registrar];
}
@end
