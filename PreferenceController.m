//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Billy Kimble on 1/20/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import "PreferenceController.h"

@implementation PreferenceController

-(id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}


- (void)windowDidLoad{
    [super windowDidLoad];
    NSLog(@"pref windo wload");
}

- (IBAction)changeBackgroundColor:(id)sender {
    NSColor *color = [colorWell color];
    NSLog(@"color changed");
}


- (IBAction)changeNewEmptyDoc:(id)sender    {
    NSInteger *state = [checkbox state];
    NSLog(@"check");
}

@end
