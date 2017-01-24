//
//  AppDelegate.m
//  OrtcClient
//
//  Created by iOSdev on 9/20/13.
//  Copyright (c) 2013 Realtime.co All rights reserved.
//

#import "RealtimePushAppDelegate.h"
#import "OrtcClient.h"
#import <UserNotifications/UserNotifications.h>

@implementation RealtimePushAppDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        [application registerForRemoteNotifications];
    }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes: UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge];
        
    }
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    [application registerForRemoteNotificationTypes: UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge];
#endif
    
    return YES;
}
#pragma clang diagnostic pop

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n\n - didRegisterForRemoteNotificationsWithDeviceToken:\n%@\n", deviceToken);
    
    [OrtcClient performSelector:@selector(setDEVICE_TOKEN:) withObject:[[NSString alloc] initWithString:newToken]];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	//NSLog(@"\n\n - didReceiveRemoteNotification:\n%@\n", userInfo);
	
    // Handle the notification here
    //clear notifications
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // set application badge number
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
	/*
	if (application.applicationState != UIApplicationStateActive) {
		// app was just brought from background to foreground
	}
	*/
	
	// Write to NSUserDefaults
	if ([userInfo objectForKey:@"C"] && [userInfo objectForKey:@"M"] && [userInfo objectForKey:@"A"]) {
		
		NSString *ortcMessage;
		
        NSRegularExpression* valRegex = [NSRegularExpression regularExpressionWithPattern:@"^#(.*?):" options:0 error:NULL];
        NSTextCheckingResult* valMatch = [valRegex firstMatchInString:[userInfo objectForKey:@"M"] options:0 range:NSMakeRange(0, [[userInfo objectForKey:@"M"] length])];
        NSRange strRangeSeqId = [valMatch rangeAtIndex:1];
        NSString* seqId;
        NSString* message;
        
        if (valMatch && strRangeSeqId.location != NSNotFound) {
            seqId = [[userInfo objectForKey:@"M"] substringWithRange:strRangeSeqId];
            NSArray* parts = [[userInfo objectForKey:@"M"] componentsSeparatedByString:[NSString stringWithFormat:@"#%@:", seqId]];
            message = [parts objectAtIndex:1];
        }
        
        if (seqId != nil && ![seqId isEqualToString:@""]) {
            ortcMessage = [NSString stringWithFormat:@"a[\"{\\\"ch\\\":\\\"%@\\\",\\\"m\\\":\\\"%@\\\",\\\"s\\\":\\\"%@\\\"}\"]", [userInfo objectForKey:@"C"], message, seqId];
        }else{
            ortcMessage = [NSString stringWithFormat:@"a[\"{\\\"ch\\\":\\\"%@\\\",\\\"m\\\":\\\"%@\\\"}\"]", [userInfo objectForKey:@"C"], [userInfo objectForKey:@"M"]];
        }
        
		NSMutableDictionary *notificationsDict  = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATIONS_KEY]];
		NSMutableDictionary *notificationsArray = [[NSMutableDictionary alloc] init];
		[notificationsArray setObject:@NO forKey:ortcMessage];
        
		[notificationsDict setObject:notificationsArray forKey:[userInfo objectForKey:@"A"]];
		[[NSUserDefaults standardUserDefaults] setObject:notificationsDict forKey:NOTIFICATIONS_KEY];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ApnsNotification" object:nil userInfo:userInfo];
	}
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to register with error : %@", error);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ApnsRegisterError" object:nil userInfo:[NSDictionary dictionaryWithObject:error forKey:@"ApnsRegisterError"]];
}


@end
