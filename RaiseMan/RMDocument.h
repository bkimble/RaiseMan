//
//  RMDocument.h
//  RaiseMan
//
//  Created by Billy Kimble on 1/16/14.
//  Copyright (c) 2014 Billy Kimble. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RMDocument : NSDocument {
    NSMutableArray *employees;
}
- (void)setEmployees:(NSMutableArray *)a;
@end
