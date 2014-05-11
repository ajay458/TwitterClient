//
//  TwitterTableViewCell.m
//  TwitterClient
//
//  Created by Apple on 07/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import "TwitterTableViewCell.h"
#import "AsyncImageView.h"

@interface TwitterTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet AsyncImageView *userImage;
@property (weak, nonatomic) IBOutlet UIWebView *tweetWebView;

@end

@implementation TwitterTableViewCell


- (void)awakeFromNib
{
    // Initialization code
    _tweetWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    _tweetWebView.delegate = self;
    [_userImage.layer setCornerRadius:_userImage.frame.size.width/2];
    [_userImage setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//https://api.twitter.com/1.1/users/show.json?screen_name=%@

- (void)setTweetValuesToCellComponents:(Tweet*)userTweet
{
    _userImage.image = [UIImage imageNamed:@"white_patch"];
    NSURL *imageUrl=[NSURL URLWithString:userTweet.userImageUrlString];
    _userImage.imageURL = imageUrl;
    
    _lblUserName.text = userTweet.userName;
    
    [_tweetWebView loadHTMLString:[userTweet.tweetedMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
    
}

#pragma mark UIWebViewDelegate


@end
