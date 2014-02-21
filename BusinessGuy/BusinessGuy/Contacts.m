//
//  Contacts.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 8/24/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "Contacts.h"
#import "ABPersonCell.h"
#import "AddressBookSingleton.h"
#import "ABPersonViewController+Extras.h"
#import "SVProgressHUD.h"
#import "Snapshot.h"
#import "AddressBook.h"
#import "NSDate+TimeAgo.h"
#import "UIAlertView+Blocks.h"

@implementation Contacts

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.nameSorted = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContacts];
}

- (void) viewWillAppear:(BOOL)animated {
    ABRecordID recordID = ABRecordGetRecordID(self.lastPerson);
    NSNumber *recordNumber = [NSNumber numberWithInt:recordID];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:recordNumber forKey:@"recordNumber"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotRecordNumber" object:nil userInfo:userInfo];
    [super viewWillAppear:animated];
    [self loadContacts];
    [[Snapshot sharedInstance] stopCameraSession];
    
    //manually set brightness for a bright capture.
    [UIScreen mainScreen].brightness = 1.0;
}


- (void)loadContacts {
    [AddressBook sharedInstance].addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookRequestAccessWithCompletion != NULL){
        
        ABAddressBookRequestAccessWithCompletion([AddressBook sharedInstance].addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"Error");
                CFRelease(error);
            } else {
                [self.tableView reloadData];
            }
        });
    }
    
    [[AddressBook sharedInstance] checkIfContactDeleted];

    self.allPeople = ABAddressBookCopyArrayOfAllPeople([AddressBook sharedInstance].addressBook);
    self.nPeople = ABAddressBookGetPersonCount([AddressBook sharedInstance].addressBook);
    
    self.people = [[NSMutableArray alloc] init];
    for ( int i = 0; i < self.nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( self.allPeople, i );
        ABPerson *person = [[ABPerson alloc] init];
        [person setFirstName:CFBridgingRelease(ABRecordCopyValue(ref, kABPersonFirstNameProperty))];
        [person setLastName:CFBridgingRelease(ABRecordCopyValue(ref, kABPersonLastNameProperty))];
        [person setCreatedAt: CFBridgingRelease(ABRecordCopyValue(ref, kABPersonCreationDateProperty))];
        
        
        [person setMobile:CFBridgingRelease(ABRecordCopyValue(ref, kABPersonPhoneProperty))];
        [person setRef:ref];
        
        CFDataRef imageData = ABPersonCopyImageData(ref);
        if (imageData != nil) {
            [person setPortrait:[UIImage imageWithData:CFBridgingRelease(imageData)]];
            CFRelease(imageData);
        } else
            [person setPortrait:nil];
        [self.people addObject:person];
    }
    
    //sort the dates.
    NSSortDescriptor *descriptor;
    descriptor = self.nameSorted ? [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO] : [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    [self.people sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    self.sections = nil;
//    self.sortedItems = nil;
    self.sections = [NSMutableDictionary dictionary];
//    self.sortedItems = [NSMutableArray array];
    
    if (!self.nameSorted) {
        //sort by date! :D
        for (ABPerson *person in self.people) {
                NSMutableArray *eventsOnThisDay = [self.sections objectForKey:person.createdAt.timeAgo];
            if (eventsOnThisDay == nil) {
                eventsOnThisDay = [NSMutableArray array];
                
                // Use the reduced date as dictionary key to later retrieve the event list this day
                [self.sections setObject:eventsOnThisDay forKey:person.createdAt.timeAgo];
            }
            
            // Add the event to the list for this day
            [eventsOnThisDay addObject:person];
        }
        self.sortedItems = [[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)];
    } else {
        for (ABPerson *person in self.people) {
            NSString *letter = [person.firstName substringToIndex:1];
            if (letter == nil)
                letter = @" ";
            NSMutableArray *eventsOnThisLetter = [self.sections objectForKey:letter];
            if (eventsOnThisLetter == nil) {
                eventsOnThisLetter = [NSMutableArray array];
                
                // Use the reduced date as dictionary key to later retrieve the event list this day
                [self.sections setObject:eventsOnThisLetter forKey:letter];
            }
            
            // Add the event to the list for this day
            [eventsOnThisLetter addObject:person];
        }
        self.sortedItems = [[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedItems objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.sortedItems objectAtIndex:section];
    if ([title length] > 2)
        if ([title characterAtIndex:2] == ')')
            title = [title substringFromIndex:4];
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ABPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSDate *dateRepresentingThisDay = [self.sortedItems objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    ABPerson *person = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    NSString *firstName = person.firstName;
    if (firstName == nil)
        firstName = @"";
    
    NSString *lastName = person.lastName;
    if (lastName == nil)
        lastName = @"";
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    if (person.portrait != nil) 
        cell.portrait.image = person.portrait;
    else
        cell.portrait.image = nil;
    
    
    cell.person = person;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABPersonCell *cell = (ABPersonCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    ABPersonViewController *addressBookVC = [[ABPersonViewController alloc] init];
    addressBookVC.personViewDelegate = self;
    addressBookVC.allowsEditing = YES;
    addressBookVC.displayedPerson = cell.person.ref;
    
    NSLog(@"Editing Person: %@", cell.person.ref);
    [AddressBook sharedInstance].currentPerson = cell.person.ref;
    addressBookVC.addressBook = [AddressBook sharedInstance].addressBook;
//    [addressBookVC allowsDeleting];
    [[Snapshot sharedInstance] startCameraSession];
    
    [addressBookVC setAllowsEditing:YES];
    [addressBookVC setAllowsActions:YES];
    
    [[self navigationController] pushViewController:addressBookVC animated:YES];
}

#pragma mark - Actions
- (IBAction)addContact:(id)sender {
//    ABRecordRef person = [self personObject];
//    self.lastPerson = person;
//    ABPersonViewController *addressBookVC = [[ABPersonViewController alloc] init];
//    addressBookVC.displayedPerson = person;
//    [AddressBook sharedInstance].currentPerson = person;
//    addressBookVC.personViewDelegate = self;
//    addressBookVC.allowsEditing = YES;
//    addressBookVC.addressBook = [AddressBook sharedInstance].addressBook;
//    [addressBookVC setEditing:YES];
//    [[Snapshot sharedInstance] startCameraSession];
//    
//    [[self navigationController] pushViewController:addressBookVC animated:YES];
//    [addressBookVC setEditing:YES animated:NO];
    [AddressBook sharedInstance].currentPerson = nil;
    ABNewPersonViewController *addressbookVC = [[ABNewPersonViewController alloc] init];
    addressbookVC.newPersonViewDelegate = self;
    [[Snapshot sharedInstance] startCameraSession];
    
    addressbookVC.hidesBottomBarWhenPushed = YES;
    self.hidesBottomBarWhenPushed = NO;
    
    [[self navigationController] pushViewController:addressbookVC animated:YES];
    
}

- (void)newPersonViewController:(ABNewPersonViewController *)
newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    //todo: create the person.
    
    AddressBook *ab = [AddressBook sharedInstance];
    NSLog(@"New Person, Setting to  %@", person);
    ab.currentPerson = person;
    [ab updateUnallocatedPhotos];
    [[Snapshot sharedInstance] stopCameraSession];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)toggleContactsList:(id)sender {
    self.nameSorted = !self.nameSorted;
    if (self.nameSorted)
        self.toggleButton.title = @"Name";
    else
        self.toggleButton.title = @"Date";
    [self loadContacts];
}

#pragma mark - ABPersonDelegate
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return YES;
}

- (ABRecordRef)personObject {
    ABRecordRef newRecord = ABPersonCreate();
    ABAddressBookAddRecord([AddressBook sharedInstance].addressBook, newRecord, nil);
    return newRecord;
}

#pragma mark - Delete Contacts
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //console.log delete this contact
        ABPersonCell *cell = (ABPersonCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        
        __block ABRecordRef personRef = cell.person.ref;
        
        [UIAlertView showWithTitle:@"Confirm"
                           message:[NSString stringWithFormat:@"Are you sure you want to delete this contact, %@ %@", cell.person.firstName ?: @"", cell.person.lastName ?: @""]
                 cancelButtonTitle:@"No"
                 otherButtonTitles:@[@"Yes"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == [alertView cancelButtonIndex]) {
                                  NSLog(@"Cancelled");
                              } else {
                                  NSLog(@"Have a cold beer");
                                  ABAddressBookRemoveRecord([AddressBook sharedInstance].addressBook, personRef, nil);
                                  ABAddressBookSave([AddressBook sharedInstance].addressBook, nil);
                                  
                                  [self loadContacts];
                              }
                          }];
    }
}


@end
