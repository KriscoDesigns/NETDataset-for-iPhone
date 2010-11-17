//
//  DatasetParserAppDelegate.m
//  DatasetParser
//
//  Created by Kris Bray on 10-05-27.
//  Copyright Imperium 2010. All rights reserved.
//

#import "DatasetParserAppDelegate.h"
#import "DatasetParserViewController.h"

@implementation DatasetParserAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch   
	viewController = [[DatasetParserViewController alloc] initWithNibName:@"DatasetParserView" bundle:nil];
	[window addSubview:viewController.view];
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
