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

@implementation Contacts

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContacts];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadContacts];
    [[Snapshot sharedInstance] stopCameraSession];
}


- (void)loadContacts {
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED > 60000
    [AddressBook sharedInstance].addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookRequestAccessWithCompletion != NULL){
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"Error");
                CFRelease(error);
            }
        });
    }
#else
    [AddressBook sharedInstance].addressBook = ABAddressBookCreate();
#endif

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
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    [self.people sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nPeople;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ABPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ABPerson *person = [self.people objectAtIndex:[indexPath row]];
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
    [AddressBook sharedInstance].currentPerson = cell.person.ref;
    addressBookVC.addressBook = [AddressBook sharedInstance].addressBook;
    [addressBookVC allowsDeleting];
    [[Snapshot sharedInstance] startCameraSession];
    
    [[self navigationController] pushViewController:addressBookVC animated:YES];
}

#pragma mark - Actions
- (IBAction)addContact:(id)sender {
    ABRecordRef person = [self personObject];
    ABPersonViewController *addressBookVC = [[ABPersonViewController alloc] init];
    addressBookVC.displayedPerson = person;
    [AddressBook sharedInstance].currentPerson = person;
    addressBookVC.personViewDelegate = self;
    addressBookVC.allowsEditing = YES;
    addressBookVC.addressBook = [AddressBook sharedInstance].addressBook;
    [addressBookVC setEditing:YES];
    [[Snapshot sharedInstance] startCameraSession];
    
    [[self navigationController] pushViewController:addressBookVC animated:YES];
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


@end
