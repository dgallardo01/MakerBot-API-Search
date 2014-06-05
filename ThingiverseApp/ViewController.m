//
//  ViewController.m
//  Testing
//
//  Created by Danny on 5/31/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "ViewController.h"
#import "NewThing.h"
#import "ThingsTableViewController.h"
#import "ThingiverseAPIClient.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) ThingiverseAPIClient *apiClient;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.webview setDelegate:self];
    self.apiClient = [[ThingiverseAPIClient alloc]init];
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"thingiverseAccessToken"];
    
    if (!accessToken) {
        [self.apiClient loadLoginScreenFromWebview:self.webview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.apiClient getAccessTokenFromCallbackURL:request forNavigationController:self.navigationController forViewController:self];
    return YES;
}

@end
