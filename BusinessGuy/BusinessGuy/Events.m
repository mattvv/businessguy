//
//  Events.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/4/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "Events.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Snapshot.h"

@implementation Events

Events *_sharedObject;

+ (Events *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void) registerEvent:(UIEvent*)event {
    UITouch *touch = [event.allTouches anyObject];
    if ([[touch.view class] isSubclassOfClass:[UITextField class]]) {
        NSString *className = NSStringFromClass([touch.view class]);
        if ([className isEqualToString:@"ABHighlightingTextField"]) {
            //we know its a ABHighlightingTextField, we can take a photo now
            NSLog(@"Taking Photo!");
            [[Snapshot sharedInstance] saveCurrentImage];
        }

    }
}

@end
