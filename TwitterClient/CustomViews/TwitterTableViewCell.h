//
//  TwitterTableViewCell.h
//  TwitterClient
//
//  Created by Apple on 07/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TwitterTableViewCellDelegate <NSObject>
@optional
- (void)urlClicked:(NSURL*)url;

@end


@interface TwitterTableViewCell : UITableViewCell<UIWebViewDelegate>
- (void)setTweetValuesToCellComponents:(Tweet*)userTweet;

@property (nonatomic,unsafe_unretained)id<TwitterTableViewCellDelegate>delegate;
@end
