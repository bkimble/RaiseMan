//
//  Person.m
//  RaiseMan
//
//  Created by Billy Kimble on 1/16/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize personName;
@synthesize expectedRaise;

- (id) init {
    self = [super init];
    if (self) {
        expectedRaise = 0.05;
        personName = @"New Person";
    }
    return self;
}

@end
