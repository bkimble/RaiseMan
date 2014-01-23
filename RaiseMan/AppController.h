//
//  AppController.h
//  RaiseMan
//
//  Created by Billy Kimble on 1/20/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreferenceController;

@interface AppController : NSObject {
    PreferenceController *preferenceController;
}

- (IBAction)showPreferencePanel:(id)sender;
+ (void) setDefaultPreferenceValues;

@end
