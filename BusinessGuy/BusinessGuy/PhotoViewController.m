//
//  PhotoViewController.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/5/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "PhotoViewController.h"
#import "Snapshot.h"
#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import "ViewPhotoViewController.h"

@implementation PhotoViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[AddressBook sharedInstance].photoDictionary count] > 0) {
        return [[AddressBook sharedInstance].photoDictionary count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[AddressBook sharedInstance].photoDictionary count] == 0) {
        self.tableView.tableFooterView = self.theSkinny;
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"";
        //whatever else to configure your one cell you're going to return
        return cell;

    } else {
        self.tableView.tableFooterView = nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }

    NSNumber *recordNumber = [[[AddressBook sharedInstance].photoDictionary allKeys] objectAtIndex:indexPath.row];
    ABRecordID recordID = (ABRecordID) [recordNumber intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID([AddressBook sharedInstance].addressBook, recordID);
    cell.textLabel.text = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    cell.detailTextLabel.text = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"viewPhoto" sender:indexPath];
}

#pragma mark - segue fun
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewPhoto"]) {
        NSIndexPath *indexPath = (NSIndexPath *) sender;
        NSNumber *recordNumber = [[[AddressBook sharedInstance].photoDictionary allKeys] objectAtIndex:indexPath.row];
        ViewPhotoViewController *viewPhoto = (ViewPhotoViewController *) segue.destinationViewController;
        viewPhoto.photos = nil;
        viewPhoto.photos = [[AddressBook sharedInstance].photoDictionary objectForKey:recordNumber];
    }
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
        cell
        
        __block ABRecordRef personRef = cell.person.ref;
        
        [UIAlertView showWithTitle:@"Confirm"
                           message:[NSString stringWithFormat:@"Are you sure you want to delete this contact, %@ %@", cell.person.firstName ?: @"", cell.person.lastName ?: @""]
                 cancelButtonTitle:@"Cancel"
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
