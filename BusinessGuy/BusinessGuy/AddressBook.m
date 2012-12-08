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
    
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.8);
    NSString *savePath = uniqueSavePath();
    [imageData writeToFile:savePath atomically:YES];
    
    if ([self.photoDictionary objectForKey:recordNumber])
        photoList = (NSMutableArray *) [self.photoDictionary objectForKey:recordNumber];
    else {
        photoList = [NSMutableArray array];
        [self.photoDictionary setObject:photoList forKey:recordNumber];
    }
    
    [photoList addObject:savePath];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[AddressBook sharedInstance].photoDictionary];
    [userDefaults setObject:data forKey:@"photoDictionary"];
    [userDefaults synchronize];
}

NSString *uniqueSavePath() {
    int i = 1;
    NSString *path;
    do {
        //iterate until a name does not match an existing file:
        path = [NSString stringWithFormat:@"%@/Documents/IMAGE_%04d.jpg", NSHomeDirectory(), i++];
    } while ([[NSFileManager defaultManager] fileExistsAtPath:path]);
    
    return path;
}


@end
