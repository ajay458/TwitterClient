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
@synthesize delegate;


- (void)awakeFromNib
{
    // Initialization code
    _tweetWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    _tweetWebView.delegate = self;
    [_userImage.layer setCornerRadius:_userImage.frame.size.width/2];
    [_userImage setClipsToBounds:YES];
    UIFont* pacificoFont = [UIFont fontWithName:@"pacifico"
                                           size:15];
    [_lblUserName setFont:pacificoFont];
    [_lblUserName setTextColor:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTweetValuesToCellComponents:(Tweet*)userTweet
{
    _userImage.image = [UIImage imageNamed:@"white_patch"];
    NSURL *imageUrl=[NSURL URLWithString:userTweet.userImageUrlString];
    _userImage.imageURL = imageUrl;
    
    _lblUserName.text = userTweet.userName;
    
    [_tweetWebView loadHTMLString:[userTweet.tweetedMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
    
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        
        if([self.delegate respondsToSelector:@selector(urlClicked:)])
        {
            [self.delegate urlClicked:request.URL];//Handle External URL here
            return NO;
        }
        
    }
    
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; 
    
    CGRect mWebViewFrame = webView.frame;
    
    
    mWebViewFrame.size.height = mWebViewTextSize.height;
    
    webView.frame = mWebViewFrame;
    
    
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
    
}
@end
