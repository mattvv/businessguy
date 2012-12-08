//
//  Contacts.h
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 8/24/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "ABPerson.h"
#import <AddressBookUI/AddressBookUI.h>
#import "ABPersonViewController+Extras.h"

@interface Contacts : UITableViewController <UITableViewDataSource, UITableViewDelegate, ABPersonViewControllerDelegate>

@property (nonatomic) CFArrayRef allPeople;
@property (nonatomic) CFIndex nPeople;
@property (nonatomic, retain) NSMutableArray* people;

- (IBAction)addContact:(id)sender;

@end
