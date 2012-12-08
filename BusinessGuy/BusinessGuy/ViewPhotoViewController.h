//
//  ViewPhotoViewController.h
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/8/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPageControl.h"

@interface ViewPhotoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) IBOutlet CSPageControl *pageControl;

@end
