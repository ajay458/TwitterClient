//
//  Tweet.h
//  TwitterClient
//
//  Created by Apple on 11/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property(nonatomic,strong)NSString *userImageUrlString;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *tweetedMessage;

@end
