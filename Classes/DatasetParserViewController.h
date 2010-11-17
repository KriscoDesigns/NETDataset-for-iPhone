//
//  DatasetParserViewController.h
//  DatasetParser
//
//  Created by Kris Bray on 10-05-27.
//  Copyright 2010 Imperium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheDBCommands.h"

@interface DatasetParserViewController : UITableViewController <CacheDBDelegate, UITableViewDelegate, UITableViewDataSource>{
	NSMutableArray *data;
	IBOutlet UIActivityIndicatorView *act;
	CacheDBCommands *cacheDB;
}
@property(nonatomic, retain) NSMutableArray *data;
@property(nonatomic, retain) UIActivityIndicatorView *act;

@end
