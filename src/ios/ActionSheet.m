#import "ActionSheet.h"

@implementation ActionSheet

NSString* theCallbackId;

- (void) show:(CDVInvokedUrlCommand*)command {
    theCallbackId = command.callbackId;
    NSDictionary* options = [command.arguments objectAtIndex:0];

    NSString *title  = [options objectForKey:@"title"] ?: nil;
    NSArray *buttons = [options objectForKey:@"buttonLabels"];
    NSString *addCancelButtonWithLabel = [options objectForKey:@"addCancelButtonWithLabel"] ?: nil;
    NSString *addDestructiveButtonWithLabel = [options objectForKey:@"addDestructiveButtonWithLabel"] ?: nil;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:addDestructiveButtonWithLabel
                                                    otherButtonTitles:nil];

    for(int i = 0; i < [buttons count]; i++) {
        [actionSheet addButtonWithTitle:[buttons objectAtIndex:i]];
    }

    if (addCancelButtonWithLabel != nil) {
        [actionSheet addButtonWithTitle:addCancelButtonWithLabel];
        actionSheet.cancelButtonIndex = [buttons count]+(addDestructiveButtonWithLabel == nil ? 0 : 1);
    }

    [actionSheet showInView:self.webView.superview];
}

// delegate function of UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    // ActionSheet button index is 0-based, but other Cordova plugins are 1-based (prompt, confirm)
    buttonIndex++;
    
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsInt:buttonIndex];
    [self writeJavascript: [pluginResult toSuccessCallbackString:theCallbackId]];
}

@end