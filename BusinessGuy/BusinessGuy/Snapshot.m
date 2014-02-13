//
//  Snapshot.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/4/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "Snapshot.h"
#import "AddressBook.h"
#import "UIImage+Resize.h"

// Required import... Also need AudioToolbox.framework
#import <AudioToolbox/AudioToolbox.h>

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
    UIImage *source = self.camera.currentImage;
    CGRect             r ;
    UIImageOrientation o ;
    int                w ;
    int                h ;
    
    o = source.imageOrientation;
    
    switch(o)
    {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            w = IMG_SIZE_DIM_X;
            h = IMG_SIZE_DIM_Y;
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            w = IMG_SIZE_DIM_Y;
            h = IMG_SIZE_DIM_X;
            break;
            
    }
    r = [CameraImageHelper getFittedImageRect:source fitInRect:CGRectMake(0.f,0.f,(CGFloat)w, (CGFloat)h)];
    
    source = [source resizedImage:r.size interpolationQuality:kCGInterpolationHigh];
    [[AddressBook sharedInstance] addPhoto:source];
    // ivar
    // Play the sound
    AudioServicesPlaySystemSound(1108);
}

@end
