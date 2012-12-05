//
//  UIApplication+BusinessGuy.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/4/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "UIApplication+BusinessGuy.h"
#import "Events.h"

@implementation UIApplication (BusinessGuy)

- (void) fakeSendEvent:(UIEvent*)event
{
    [[Events sharedInstance] registerEvent: event];
    
    // Note this won't endlessly loop as this will have been swizzeled...
    [self fakeSendEvent:event];
}

@end
