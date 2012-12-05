//
//  PhotoViewController.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/5/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "PhotoViewController.h"
#import "Snapshot.h"

@implementation PhotoViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.lastImage.image = [Snapshot sharedInstance].lastImage;
}

@end
