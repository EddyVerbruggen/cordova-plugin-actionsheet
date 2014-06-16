#import "ActionSheet.h"

@implementation ActionSheet

- (void) show:(CDVInvokedUrlCommand*)command {

    NSString *options = [command.arguments objectAtIndex:0];
    NSString *callbackId = command.callbackId;

    NSString *title = [options objectForKey:@"title"] ?: @"";
    NSString *style = [options objectForKey:@"style"] ?: @"black-translucent";
    //NSString *style = [options objectForKey:@"style"] ?: @"default";
    NSArray *buttons = [options objectForKey:@"buttons"];
    //NSInteger cancelButtonIndex = [[options objectForKey:@"cancelButtonIndex"] intValue] ?: false;
    //NSInteger destructiveButtonIndex = [[options objectForKey:@"destructiveButtonIndex"] intValue] ?: false;

    // Create actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

    // Style actionSheet, defaults to UIActionSheetStyleDefault
    if([style isEqualToString:@"black-opaque"]) actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    else if([style isEqualToString:@"black-translucent"]) actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    else actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    // Fill with elements
    for(int i = 0; i < [buttons count]; i++) {
      [actionSheet addButtonWithTitle:[buttons objectAtIndex:i]];
    }
    // Handle cancelButtonIndex
    //if([options objectForKey:@"cancelButtonIndex"]) {
    //  actionSheet.cancelButtonIndex = cancelButtonIndex;
    //}
    // Handle destructiveButtonIndex
    //if([options objectForKey:@"destructiveButtonIndex"]) {
    //  actionSheet.destructiveButtonIndex = destructiveButtonIndex;
    //}

    // Toggle ActionSheet
    [actionSheet showInView:self.webView.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

	// Build returned result
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setObject:[NSNumber numberWithInteger:buttonIndex] forKey:@"buttonIndex"];

	// Create Plugin Result
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];

	// Checking if cancel was clicked
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		//Call  the Failure Javascript function
		[self writeJavascript: [pluginResult toErrorCallbackString:self.callbackId]];
	// Checking if destructive was clicked
	} else if (buttonIndex != actionSheet.destructiveButtonIndex) {
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackId]];
	// Other button was clicked
	} else {
		//Call  the Success Javascript function
		[self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackId]];
	}

/*
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                callbackId:callbackId];

    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                callbackId:command.callbackId];

*/
}

@end