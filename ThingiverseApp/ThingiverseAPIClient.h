//
//  ThingiverseAPIClient.h
//  ThingiverseApp
//
//  Created by Danny on 6/3/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingiverseAPIClient : NSObject

- (void) getNewestThingsWithCompletion:(void(^)(NSArray * things))completionBlock;

- (void) loadLoginScreenFromWebview:(UIWebView *)webView;

- (void) getAccessTokenFromCallbackURL:(NSURLRequest *)request forNavigationController:(UINavigationController *)navigationController forViewController:(UIViewController *)viewController;

- (void) searchforThing:(NSString *)searchText withCompletion:(void(^)(NSArray * things))completionBlock;

- (void) likeAThing:(NSNumber *)thingID;

@end
