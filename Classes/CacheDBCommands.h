//
//  CacheDBCommands.h
//  NETDataset
//
//  Created by Kris Bray on 10-01-22.
//  Copyright 2010 Imperium. All rights reserved.
//


#import "DataSet.h"

@class CacheDBCommands;
@protocol CacheDBDelegate <NSObject>
@optional
- (void)willStartDownloading:(CacheDBCommands *)cacheDB;
- (void)didFinishDownloading:(CacheDBCommands *)cacheDB;
- (void)shouldShowSignIn:(CacheDBCommands *)cacheDB;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
@end
@interface CacheDBCommands : NSObject {
	id <CacheDBDelegate>delegate;
	DataSet *myDataset;
	NSOperationQueue *opQueue;
	NSString *XMLNamespace;
	NSString *ServerURL;
}
@property(nonatomic, retain) DataSet *myDataset;
@property(nonatomic, retain) NSOperationQueue *opQueue;
@property(nonatomic, copy) NSString *XMLNamespace;
@property(nonatomic, copy) NSString *ServerURL;
@property(nonatomic, assign) id <CacheDBDelegate>delegate;


-(void)getMyDataset:(NSArray *)params;
-(void)initDownloadMyDataset:(NSString *)param1 Param2:(NSString *)param2;
-(void)stopAllProcesses;
-(void)reset;
@end


