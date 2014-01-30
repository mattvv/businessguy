//
//  AppDelegate.m
//  BusinessGuy
//
//  Created by Matt Van Veenendaal on 8/24/12.
//  Copyright (c) 2012 Matt Van Veenendaal. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "AddressBook.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Method myReplacementMethod = class_getInstanceMethod([UIApplication class], @selector(fakeSendEvent:));
    Method applicationSendEvent = class_getInstanceMethod([UIApplication class], @selector(sendEvent:));
    method_exchangeImplementations(myReplacementMethod, applicationSendEvent);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"photoDictionary"]) {
        NSData *data = [defaults objectForKey:@"photoDictionary"];
        [AddressBook sharedInstance].photoDictionary = (NSMutableDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [Appirater setAppId:@"552035781"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[AddressBook sharedInstance].photoDictionary forKey:@"photoDictionary"];
//    [userDefaults synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
