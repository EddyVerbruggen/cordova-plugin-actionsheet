#import <Cordova/CDVPlugin.h>

@interface ActionSheet :CDVPlugin<UIActionSheetDelegate>

- (void) show:(CDVInvokedUrlCommand*)command;

@end
