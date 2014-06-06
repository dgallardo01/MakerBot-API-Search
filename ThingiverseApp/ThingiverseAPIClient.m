//
//  ThingiverseAPIClient.m
//  ThingiverseApp
//
//  Created by Danny on 6/3/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "ThingiverseAPIClient.h"
#import "NewThing.h"
#import "ThingsTableViewController.h"
#import "Constants.h"

@interface ThingiverseAPIClient ()

@property (strong, nonatomic) NSOperationQueue *apiOperation;

@end

@implementation ThingiverseAPIClient

- (void) getNewestThingsWithCompletion:(void(^)(NSArray * things))completionBlock{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"thingiverseAccessToken"];
    
    NSString *getUserInfo = [NSString stringWithFormat:@"https://api.thingiverse.com/newest?access_token=%@", accessToken];
    
    NSURL *userInfoURL = [NSURL URLWithString:getUserInfo];
    
    NSMutableURLRequest *userInfoURLRequest = [NSMutableURLRequest requestWithURL:userInfoURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:userInfoURLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *things = [NewThing thingArrayFromThingDictionaries:responseDictionary];
            completionBlock(things);
    }];
    [dataTask resume];
}

- (void) loadLoginScreenFromWebview:(UIWebView *)webView{
    NSString *thingiverseAuthString =[NSString stringWithFormat:@"https://www.thingiverse.com/login/oauth/authorize?client_id=%@", CLIENT_ID];
    
    //Call the auth in a browser
    NSURL *thingiverseURL = [NSURL URLWithString:thingiverseAuthString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:thingiverseURL];
    [webView loadRequest:urlRequest];
}

//Get Access Token and dismiss view controller afterwards
- (void) getAccessTokenFromCallbackURL:(NSURLRequest *)request forNavigationController:(UINavigationController *)navigationController forViewController:(UIViewController *)viewController{
    NSString *responseURL = [NSString stringWithFormat:@"%@",request.URL];
    
    
    NSString *pattern = @"\\Ahttp:\\/\\/dannygallardo\\.com\\/callback\\.html\\?code\\=(.+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regex matchesInString:responseURL options:0 range:NSMakeRange(0, [responseURL length])];
    for (NSTextCheckingResult *match in matches){
        NSString *code =[responseURL substringWithRange:[match rangeAtIndex:1]];
        NSLog(@"Code: %@",code);
        
        NSURL *getAccessTokenURL = [NSURL URLWithString:@"https://www.thingiverse.com/login/oauth/access_token"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:getAccessTokenURL];
        request.HTTPMethod = @"POST";
        
        NSString *params = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",CLIENT_ID, CLIENT_Secret,code];
        
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString *tokenPattern = @"\\Aaccess_token=(.+)&token";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:tokenPattern options:0 error:nil];
            NSArray *matches = [regex matchesInString:responseString options:0 range:NSMakeRange(0, [responseString length])];
            for (NSTextCheckingResult *match in matches) {
                NSString *accessToken = [responseString substringWithRange:[match rangeAtIndex:1]];
                NSLog(@"AccessToken: %@",accessToken);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:accessToken forKey:@"thingiverseAccessToken"];
                [defaults synchronize];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ThingsTableViewController *tableView = [storyBoard instantiateViewControllerWithIdentifier:@"tableViewController"];
                [navigationController presentViewController:tableView animated:YES completion:nil];
                NSLog(@"access token found");
            }
        }];
        [dataTask resume];
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) searchforThing:(NSString *)searchText withCompletion:(void(^)(NSArray * things))completionBlock{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"thingiverseAccessToken"];
    
    NSString *getUserInfo = [NSString stringWithFormat:@"https://api.thingiverse.com/search/%@?access_token=%@", searchText, accessToken];
    
    NSURL *userInfoURL = [NSURL URLWithString:getUserInfo];
    
    NSMutableURLRequest *userInfoURLRequest = [NSMutableURLRequest requestWithURL:userInfoURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:userInfoURLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *things = [NewThing thingArrayFromThingDictionaries:responseDictionary];
                completionBlock(things);
    }];
    [dataTask resume];
}


@end
