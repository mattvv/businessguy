//
//  Snapshot.h
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/4/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraImageHelper.h"

@interface Snapshot : NSObject

+ (Snapshot *)sharedInstance;
- (void) startCameraSession;
- (void) stopCameraSession;
- (void) saveCurrentImage;

@property (nonatomic, retain) CameraImageHelper *camera;
@property (nonatomic, retain) UIImage *lastImage;

@end
