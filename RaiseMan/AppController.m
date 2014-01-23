//
//  AppController.m
//  RaiseMan
//
//  Created by Billy Kimble on 1/20/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void) setDefaultPreferenceValues {
    NSLog(@"Seetting defaulits");
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
    
    // put default values in dictionary
    [defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:BNREmptyDocKey];
    
    // register the dictionary as the defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
}

+ (void) initialize {
    [self setDefaultPreferenceValues];
    NSLog(@"registered defaults");
}

- (IBAction)showPreferencePanel:(id)sender {
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    [preferenceController showWindow:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    NSLog(@"app should open");
    return [PreferenceController preferenceEmptyDoc];
}

@end
