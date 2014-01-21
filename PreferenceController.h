//
//  PreferenceController.h
//  RaiseMan
//
//  Created by Billy Kimble on 1/20/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceController : NSWindowController {
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *checkbox;
}

- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;

@end
