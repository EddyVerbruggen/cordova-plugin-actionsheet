#import "ActionSheet.h"

@implementation ActionSheet

NSString* theCallbackId;
UIActionSheet *actionSheet;

#pragma mark - Cordova interface methods
- (void) show:(CDVInvokedUrlCommand*)command {
  theCallbackId = command.callbackId;
  NSDictionary* options = command.arguments[0];
  
  NSString *title  = options[@"title"] ?: nil;
  NSArray *buttons = options[@"buttonLabels"];
  NSArray *position = options[@"position"] ?: nil;
  NSString *addCancelButtonWithLabel = options[@"addCancelButtonWithLabel"] ?: nil;
  NSString *addDestructiveButtonWithLabel = options[@"addDestructiveButtonWithLabel"] ?: nil;
  
  [self.commandDelegate runInBackground:^{

    actionSheet = [[UIActionSheet alloc] initWithTitle:[self encodeString:title]
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:[self encodeString:addDestructiveButtonWithLabel]
                                     otherButtonTitles:nil];
    
    for(int i = 0; i < [buttons count]; i++) {
      [actionSheet addButtonWithTitle:[self encodeString:buttons[i]]];
    }
    
    if (addCancelButtonWithLabel != nil) {
      [actionSheet addButtonWithTitle:[self encodeString:addCancelButtonWithLabel]];
      actionSheet.cancelButtonIndex = [buttons count]+(addDestructiveButtonWithLabel == nil ? 0 : 1);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (position!= nil) {
          CGRect rect = [self getPopupRectFromIPadPopupCoordinates:position];
          [actionSheet showFromRect:rect inView:self.webView.superview animated:YES];
        } else {
          [actionSheet showInView:self.webView.superview];
        }
      }
      else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.webView.superview];
      }
    });
  }];
}

- (void) hide:(CDVInvokedUrlCommand*)command {
  dispatch_async(dispatch_get_main_queue(), ^{
    // dismissing with -2 because it's +1'd by didDismissWithButtonIndex below and we want it to report -1
    [actionSheet dismissWithClickedButtonIndex:-2 animated:true];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:theCallbackId];
  });
}

#pragma mark - helper methods
- (NSString*) encodeString:(NSString*)input {
  if (input == nil) {
    return nil;
  } else {
    return input;
  }
}

- (CGRect)getPopupRectFromIPadPopupCoordinates:(NSArray*)comps {
  CGRect rect = CGRectZero;
  if ([comps count] == 2) {
    rect = CGRectMake([[comps objectAtIndex:0] integerValue], [[comps objectAtIndex:1] integerValue], 0, 0);
  } else if ([comps count] == 4) {
    rect = CGRectMake([[comps objectAtIndex:0] integerValue], [[comps objectAtIndex:1] integerValue], [[comps objectAtIndex:2] integerValue], [[comps objectAtIndex:3] integerValue]);
  }
  return rect;
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  
  // ActionSheet button index is 0-based, but other Cordova plugins are 1-based (prompt, confirm)
  buttonIndex++;
  
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)buttonIndex];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:theCallbackId];
}

@end
