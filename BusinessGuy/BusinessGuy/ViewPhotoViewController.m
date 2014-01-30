//
//  ViewPhotoViewController.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/8/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "ViewPhotoViewController.h"
#import "CameraImageHelper.h"

@implementation ViewPhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.scrollView.frame = CGRectMake(0,0,320,480);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * [self.photos count], self.scrollView.bounds.size.height);
    
    int count = 0;
    for (NSString *photoPath in self.photos) {
        NSData *imageData = [NSData dataWithContentsOfFile:photoPath];
        UIImage *photo = [UIImage imageWithData:imageData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:photo];
        imageView.frame = [CameraImageHelper getFittedImageRect:photo fitInRect:CGRectMake(self.scrollView.bounds.size.width * count, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        [self.scrollView addSubview:imageView];
        count++;
    }
    self.pageControl.numberOfPages = [self.scrollView.subviews count];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Scroll View Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)theScrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        return;
    }
    
    [self calculatePageFor:theScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    [self calculatePageFor:theScrollView];
}

- (void)calculatePageFor:(UIScrollView *)theScrollView
{
    NSInteger page = (int)theScrollView.contentOffset.x / (int)theScrollView.bounds.size.width;
    
    if (self.pageControl.currentPage != page)
    {
        [self.pageControl setCurrentPage:page];
    }
}


@end
