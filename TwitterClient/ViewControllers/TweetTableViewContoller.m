//
//  TwittTableViewController.m
//  TwitterClient
//
//  Created by Apple on 07/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import "TweetTableViewContoller.h"
#import "TwitterTableViewCell.h"
#import "ODRefreshControl.h"
#import "TwitterCommunicator.h"
#import "FHSTwitterEngine.h"
#import "WebViewController.h"


@interface TweetTableViewContoller ()<TwitterTableViewCellDelegate>
@property (nonatomic,strong)ODRefreshControl *refreshControl;
@property (nonatomic,strong)NSArray *tweetsInfoArray;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,assign)BOOL isMovingToChild;

@end

@implementation TweetTableViewContoller
@synthesize refreshControl = _refreshControl;
@synthesize tweetsInfoArray = _tweetsInfoArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"TwitterTableViewCell" bundle:nil] forCellReuseIdentifier:@"TwitterCell"];
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(tableviewDidBeginRefresh:) forControlEvents:UIControlEventValueChanged];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
    if(!_isMovingToChild)
    {
        [self updateTweets];

    }
    else
    {
        _isMovingToChild = NO;
    }
    
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(!_isMovingToChild)
    {
        _tweetsInfoArray = nil;
        _userName = nil;
        [self.tableView reloadData];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Support Methods
- (void)updateTweets
{
    _userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(_userName.length>0)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id timelineInfo = [[FHSTwitterEngine sharedEngine] getHomeTimelineSinceID:@"100" count:100];//first param for inital id secound param for fetching only 100 tweets
            dispatch_async( dispatch_get_main_queue(), ^{
                if([timelineInfo isKindOfClass:[NSError class]])
                {
                    NSError *error = (NSError*)timelineInfo;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    
                }
                else
                {
                    
                    NSArray *userTimelineArray = (NSArray*)timelineInfo;
                    NSMutableArray *tweetsObjectsArray = [[NSMutableArray alloc] initWithCapacity:userTimelineArray.count];
                    for(NSDictionary *tweetDict in userTimelineArray)
                    {
                        NSDictionary *userInfoDict = [tweetDict objectForKey:@"user"];
                        Tweet *tweet = [[Tweet alloc] init];
                        tweet.userImageUrlString = [userInfoDict objectForKey:@"profile_image_url_https"];
                        tweet.userName = [userInfoDict objectForKey:@"screen_name"];
                        tweet.tweetedMessage = [tweetDict objectForKey:@"text"];
                        [tweetsObjectsArray addObject:tweet];
                        
                    }
                    _tweetsInfoArray = [NSArray arrayWithArray:tweetsObjectsArray];
                    
                }
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
            
            
        });
        
        
    }
}

- (void)tableviewDidBeginRefresh:(ODRefreshControl*)refreshControl
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self updateTweets];
        NSLog(@"%s",__func__);
        
    });
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellTopPadding = 10;
    CGFloat userInfoLabelHeight = 21;
    Tweet *tweet = [_tweetsInfoArray objectAtIndex:indexPath.row];
    CGSize webViewSize = [self getDynamicHeightForWidth:240 withString:tweet.tweetedMessage];
    CGSize userImageViewSize = CGSizeMake(48, 48);
    CGFloat cellHeight = cellTopPadding + userInfoLabelHeight + webViewSize.height;
    return  MAX(cellHeight, userImageViewSize.height);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _tweetsInfoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"TwitterCell";
    TwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(!cell)
    {
        cell = [[TwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    
    [cell setTweetValuesToCellComponents:[_tweetsInfoArray objectAtIndex:indexPath.row]];
    [cell setDelegate:self];
    return cell;
}

-(CGSize)getDynamicHeightForWidth:(CGFloat)width withString:(NSString*)inputString
{
    UIFont *webViewFont = [UIFont systemFontOfSize:17];// font used for label
    
    CGSize sizeS = [inputString sizeWithFont:webViewFont
                           constrainedToSize:CGSizeMake(width, 999)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    sizeS.height=sizeS.height+15;//webview default padding
    
    return sizeS;
}

- (void)urlClicked:(NSURL *)url
{
    _isMovingToChild  = YES;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webVC = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.title = @"Info";
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}



@end
