//
//  ABPersonCell.h
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 8/24/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABPerson.h"
@interface ABPersonCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *portrait;
@property (nonatomic, retain) ABPerson *person;

@end
