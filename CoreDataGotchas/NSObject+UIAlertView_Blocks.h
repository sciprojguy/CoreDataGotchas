//
//  NSObject+UIAlertView_Blocks.h
//  CoreDataGotchas
//
//  Created by Chris Woodard on 3/3/14.
//
//

#import <UIKit/UIKit.h>

// adapted from NSCookbook.

@interface NSObject (UIAlertView_Blocks)

-(void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
