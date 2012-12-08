//
//  AddressBook.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 12/8/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "AddressBook.h"

@implementation AddressBook

AddressBook *_sharedObject;

+ (AddressBook *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id) init {
    if (!(self = [super init])) return self;
    self.photoDictionary = [NSMutableDictionary dictionary];
    return self;
}

- (void) addPhoto: (UIImage *)photo {
    //write photo to disk and save the address in the array:
    NSMutableArray *photoList;
    ABRecordID recordID = ABRecordGetRecordID(self.currentPerson);
    NSNumber *recordNumber = [NSNumber numberWithInt:recordID];
    
    if ([self.photoDictionary objectForKey:recordNumber])
        photoList = (NSMutableArray *) [self.photoDictionary objectForKey:recordNumber];
    else {
        photoList = [NSMutableArray array];
        [self.photoDictionary setObject:photoList forKey:recordNumber];
    }
    
    //todo: save to disk
    [photoList addObject:photo];
}


@end
