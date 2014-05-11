//
//  TwitterCommunicator.h
//  TwitterClient
//
//  Created by Apple on 09/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterCommunicator : NSObject


+ (TwitterCommunicator*)sharedInstance;
- (void)requestForTwitterAccountsAndDetails;
- (NSDictionary*)getUserInfoDict;
- (void)requestForTweetsWithBlock:(void(^)(id,NSString*))block;
- (NSString*)getUserImageUrl;


@end
