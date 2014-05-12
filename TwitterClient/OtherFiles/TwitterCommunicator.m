//
//  TwitterCommunicator.m
//  TwitterClient
//
//  Created by Apple on 09/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import "TwitterCommunicator.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Tweet.h"

@interface TwitterCommunicator ()
@property (nonatomic,strong)ACAccountStore *accountStore;
@property (nonatomic,strong)NSMutableArray *twitterAccounts;

@end

@implementation TwitterCommunicator



+ (TwitterCommunicator*)sharedInstance
{
    static id twitterCopmmincator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        twitterCopmmincator = [[self alloc] init];
    });
    
    return twitterCopmmincator;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _accountStore = [[ACAccountStore alloc] init];
        //[self requestForTwitterAccountsAndDetails];
        
        
    }
    return self;
}

- (NSDictionary*)getUserInfoDict
{
    return nil;
}
- (void)requestForTwitterAccountsAndDetails
{
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [_accountStore requestAccessToAccountsWithType:accountType
                                           options:nil
                                        completion:^(BOOL granted, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (granted) {
                                                    //
                                                    // Get twitter accounts.
                                                    //
                                                    _twitterAccounts = [NSMutableArray arrayWithArray:[_accountStore accountsWithAccountType:accountType]];
                                                    
                                                } else {
                                                    
                                                    [_twitterAccounts removeAllObjects];
                                                }
                                            });
                                        }];
}


- (NSString*)getUserImageUrl
{
    return @"https://api.twitter.com/1.1/users/show.json?user_id=417788004&size=bigger";
}
//- (NSDictionary*)getUserInfoDict
//{
//    for(ACAccount *twitterAccountInfo in _twitterAccounts)
//    {
//        
//        
//    }
//    
//    return dict;
//}

//https://api.twitter.com/1.1/users/profile_image/

- (void)requestForTweetsWithBlock:(void(^)(id,NSString*))block//tweetsInfo
{
    if(_twitterAccounts.count > 0)
    {
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:url
                                                   parameters:nil];
        // Use first twitter account.
        [request setAccount:[_twitterAccounts objectAtIndex:0]];
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUInteger statusCode = urlResponse.statusCode;
                if (200 <= statusCode && statusCode < 300) {//checking status code between (200-299)
                    NSArray *tweets = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    NSMutableArray *tweetsObjectsArray = [[NSMutableArray alloc] initWithCapacity:tweets.count];
                    for(NSDictionary *tweetDict in tweets)
                    {
                        NSDictionary *userInfoDict = [tweetDict objectForKey:@"user"];
                        Tweet *tweet = [[Tweet alloc] init];
                        tweet.userImageUrlString = [userInfoDict objectForKey:@"profile_image_url_https"];
                        tweet.userName = [userInfoDict objectForKey:@"screen_name"];
                        tweet.tweetedMessage = [tweetDict objectForKey:@"text"];
                        [tweetsObjectsArray addObject:tweet];
                        
                    }
                    if(block)
                    {
                        block(tweetsObjectsArray,nil);
                    }
                    
                    
                } else {
                    NSDictionary *twitterErrorRoot = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    
                    NSArray *twitterErrors = [twitterErrorRoot objectForKey:@"errors"];
                    NSString *errorMessage = nil;
                    if (twitterErrors.count > 0) {
                         errorMessage = [[twitterErrors objectAtIndex:0] objectForKey:@"message"];
                        block(nil,errorMessage);
                    } else {
                        errorMessage = @"Failed to get tweets.";
                        block(nil,errorMessage);
                    }
                }
            });
        }];
    }
    else
    {
        block(nil,@"Add account in settings");
        
    }
    
    
}
@end
