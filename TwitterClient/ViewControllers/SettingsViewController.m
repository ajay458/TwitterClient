//
//  SettingsViewController.m
//  TwitterClient
//
//  Created by Apple on 07/05/14.
//  Copyright (c) 2014 Ajay. All rights reserved.
//

#import "SettingsViewController.h"
#import "AsyncImageView.h"
#import "TwitterCommunicator.h"
#import "FHSTwitterEngine.h"

@interface SettingsViewController ()<FHSTwitterEngineAccessTokenDelegate>
@property (nonatomic,weak)IBOutlet AsyncImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnSignin;
- (IBAction)signInButtonPressed:(id)sender;
@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userProfileImageView.imageURL = [NSURL URLWithString:[[TwitterCommunicator sharedInstance] getUserImageUrl]];
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"Xg3ACDprWAH8loEPjMzRg" andSecret:@"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%s",__func__);
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
     NSLog(@"%s",__func__);
}

- (IBAction)signInButtonPressed:(id)sender {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        //[_theTableView reloadData];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}


- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:ACCESS_TOKEN];
}


@end
