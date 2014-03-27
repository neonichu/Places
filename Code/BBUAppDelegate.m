//
//  BBUAppDelegate.m
//  Places
//
//  Created by Boris Bügling on 27.03.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <moves-ios-sdk/MovesAPI.h>

#import "BBUAppDelegate.h"
#import "BBUPlacesViewController.h"

static NSString* const BBUMovesClientId     = @"MyMovesClientId";
static NSString* const BBUMovesClientSecret = @"MyMovesClientSecret";
static NSString* const BBUMovesURLScheme    = @"my://movesUrlScheme";

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[MovesAPI sharedInstance] setShareMovesOauthClientId:BBUMovesClientId
                                        oauthClientSecret:BBUMovesClientSecret
                                        callbackUrlScheme:BBUMovesURLScheme];
    
    BBUPlacesViewController* placesViewController = [BBUPlacesViewController new];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:placesViewController];
    [self.window makeKeyAndVisible];
    
    [[MovesAPI sharedInstance] authorizationWithViewController:self.window.rootViewController
                                                       success:^{
                                                           [[MovesAPI sharedInstance] getUserSuccess:^(MVUser *user) {
                                                               [placesViewController refresh];
                                                           } failure:^(NSError *error) {
                                                               [self showError:error];
                                                           }];
                                                       } failure:^(NSError *error) {
                                                           [self showError:error];
                                                       }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[MovesAPI sharedInstance] canHandleOpenUrl:url]) {
        return YES;
    }

    return NO;
}

- (void)showError:(NSError*)error
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
