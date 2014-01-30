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

@interface Contacts : UITableViewController <UITableViewDataSource, UITableViewDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate>

@property (nonatomic) CFArrayRef allPeople;
@property (nonatomic) CFIndex nPeople;
@property (nonatomic, strong) NSMutableArray* people;

@property (nonatomic, assign) ABRecordRef lastPerson;

//sorting sections
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedItems;
@property (assign, nonatomic) bool nameSorted;

//top bar butotn
@property (nonatomic, retain) IBOutlet UIBarButtonItem *toggleButton;

- (IBAction)addContact:(id)sender;
- (IBAction)toggleContactsList:(id)sender;

@end
