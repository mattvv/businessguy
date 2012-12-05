//
//  ABPersonViewController+Extras.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/4/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "ABPersonViewController+Extras.h"

@implementation ABPersonViewController (Extras)

- (void) allowsDeleting {
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"allowsDeletion"];
}

@end