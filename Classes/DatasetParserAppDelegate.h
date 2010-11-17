//
//  DatasetParserAppDelegate.h
//  DatasetParser
//
//  Created by Kris Bray on 10-05-27.
//  Copyright Imperium 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatasetParserViewController;

@interface DatasetParserAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DatasetParserViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DatasetParserViewController *viewController;

@end

