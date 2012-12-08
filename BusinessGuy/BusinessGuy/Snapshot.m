//
//  Snapshot.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/4/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "Snapshot.h"
#import "AddressBook.h"

@implementation Snapshot

Snapshot *_sharedObject;

+ (Snapshot *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(id)init {
    if ( self = [super init] ) {
        self.camera = [CameraImageHelper helperWithCamera:kCameraFront];
    }
    return self;
}

- (void) startCameraSession {
    [self.camera startRunningSession];
}

- (void) stopCameraSession {
    [self.camera stopRunningSession];
}

- (void) saveCurrentImage {
    [[AddressBook sharedInstance] addPhoto:self.camera.currentImage];
}

@end
