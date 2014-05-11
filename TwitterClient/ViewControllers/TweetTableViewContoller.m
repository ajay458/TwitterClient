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


@interface TweetTableViewContoller ()
@property (nonatomic,strong)ODRefreshControl *refreshControl;
@property (nonatomic,strong)NSArray *tweetsInfoArray;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Support Methods
- (void)tableviewDidBeginRefresh:(ODRefreshControl*)refreshControl
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[TwitterCommunicator sharedInstance] requestForTweetsWithBlock:^(id tweetsArray, NSString *errorString) {
            _tweetsInfoArray = [NSMutableArray arrayWithArray:tweetsArray];
            dispatch_async(dispatch_get_main_queue(), ^{// fecthing main queue to update main thread
                
                [self.tableView reloadData];
                [refreshControl endRefreshing];
                
            });
        }];
        NSLog(@"%s",__func__);
        
    });
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    
    return cell;
}



@end
