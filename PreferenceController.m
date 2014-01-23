//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Billy Kimble on 1/20/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import "PreferenceController.h"
#import "AppController.h"


NSString * const BNRTableBgColorKey = @"BNRTableBackgroundKey";
NSString * const BNREmptyDocKey = @"BNREmptyDocumentFlag";
NSString * const BNRColorChangedNotification = @"BNRColorChanged";

@implementation PreferenceController

-(id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

- (void) renderFormElements {
    [colorWell setColor:[PreferenceController preferenceTableBgColor]];
    [checkbox setState:[PreferenceController preferenceEmptyDoc]];
}

- (IBAction)resetToDefault:(id)sender {
    [PreferenceController setPreferenceTableBgColor:[NSColor yellowColor]];
    [PreferenceController setPreferenceEmptyDoc:YES];
    [self renderFormElements];
    NSLog(@"resetting");
}

- (void)windowDidLoad{
    [super windowDidLoad];
    [self renderFormElements];
}

- (IBAction)changeBackgroundColor:(id)sender {
    NSColor *color = [colorWell color];
    [PreferenceController setPreferenceTableBgColor:color];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
//    NSLog(@"sending notifications");
    [nc postNotificationName:BNRColorChangedNotification object:self userInfo:d];
}


- (IBAction)changeNewEmptyDoc:(id)sender    {
    NSInteger state = [checkbox state];
    [PreferenceController setPreferenceEmptyDoc:state];
}

+ (NSColor *)preferenceTableBgColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:BNRTableBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}


+ (void)setPreferenceTableBgColor:(NSColor *)color {
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:BNRTableBgColorKey];
}


+ (BOOL)preferenceEmptyDoc{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:BNREmptyDocKey];
}

+ (void)setPreferenceEmptyDoc:(BOOL)emptyDoc {
    [[NSUserDefaults standardUserDefaults] setBool:emptyDoc forKey:BNREmptyDocKey];
}

@end
