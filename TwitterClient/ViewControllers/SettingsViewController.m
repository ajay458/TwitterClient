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
#import "InfomationViewController.h"

@interface SettingsViewController ()<FHSTwitterEngineAccessTokenDelegate>
@property (nonatomic,weak)IBOutlet AsyncImageView *userProfileImageView;
@property (nonatomic,weak)IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSignin;
@property (weak,nonatomic)IBOutlet UIView *userInfoBG;
@property (nonatomic,assign)BOOL isAnimationNeeded;
- (IBAction)signInButtonPressed:(id)sender;
@end

static  NSString *consumerKey = @"Xg3ACDprWAH8loEPjMzRg";
static  NSString *secretKey = @"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0";

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
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:consumerKey andSecret:secretKey];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];

    
        [self updateUSerInfoComponents];
    
}

- (void)updateUSerInfoComponents
{
    NSString *userName = [[FHSTwitterEngine sharedEngine] authenticatedUsername];
    if(userName)
    {

        [_btnSignin setTitle:@"SignOut" forState:UIControlStateNormal];
        _userInfoBG.hidden = NO;
        _userNameLabel.text = userName;
        _userProfileImageView.image = [[FHSTwitterEngine sharedEngine] getProfileImageForUsername:userName andSize:FHSTwitterEngineImageSizeNormal];
        [_userProfileImageView.layer setCornerRadius:_userProfileImageView.frame.size.width/2];
        [_userProfileImageView setClipsToBounds:YES];
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }
    else
    {

        [_btnSignin setTitle:@"Signin" forState:UIControlStateNormal];
        _userInfoBG.hidden = YES;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        
        
    }
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
    InfomationViewController *destinationVC = [segue destinationViewController];
    if([segue.identifier isEqualToString:ABOUT])
    {
        destinationVC.navigationItem.title = ABOUT;
        destinationVC.informationString = @"content about application";
        
    }
    else if ([segue.identifier isEqualToString:PRIVACY])
    {
        destinationVC.navigationItem.title = PRIVACY;
        destinationVC.informationString = @"content about privacy";
    }
    else if ([segue.identifier isEqualToString:TERMS])
    {
        destinationVC.navigationItem.title = TERMS;
        destinationVC.informationString = @"content about application terms";
    }
}

- (IBAction)signInButtonPressed:(id)sender {
    
    UIButton *selctedButton = (UIButton*)sender;
    if([selctedButton.titleLabel.text isEqualToString:@"Signin"])
    {
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            if(success)
            {
                [self updateUSerInfoComponents];
                
            }
            
        }];
        [self presentViewController:loginController animated:YES completion:nil];
 
    }
    
    else
    {
        [[FHSTwitterEngine sharedEngine] clearAccessToken];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *each in cookieStorage.cookies) {
            // put a check here to clear cookie url which starts with twitter and then delete it
            [cookieStorage deleteCookie:each];
        }
        [self updateUSerInfoComponents];
    }
}



- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:ACCESS_TOKEN];
}


@end
