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

@implementation PhotoViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AddressBook sharedInstance].photoDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    NSNumber *recordNumber = [[[AddressBook sharedInstance].photoDictionary allKeys] objectAtIndex:indexPath.row];
    ABRecordID recordID = (ABRecordID) [recordNumber intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID([AddressBook sharedInstance].addressBook, recordID);
    cell.textLabel.text = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    cell.detailTextLabel.text = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    return cell;
}
@end
