//
//  Person.h
//  RaiseMan
//
//  Created by Billy Kimble on 1/16/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    NSString *personName;
    float expectedRaise;
}

@property (readwrite, copy) NSString *personName;
@property (readwrite) float expectedRaise;

@end
