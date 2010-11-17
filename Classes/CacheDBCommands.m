//
//  CacheDBCommands.m
//  NETDataset
//
//  Created by Kris Bray on 10-01-22.
//  Copyright 2010 Imperium. All rights reserved.
//

#import "WebServiceHelper.h"
#import "CacheDBCommands.h"

@implementation CacheDBCommands
@synthesize myDataset, opQueue, delegate; 
@synthesize XMLNamespace, ServerURL;

- (void)setDelegate:(id)aDelegate {    delegate = aDelegate; /// Not retained
	//any time delegate changes reset everything
	[self reset];
}
-(id)init
{
	
	self.XMLNamespace = @"http://yourweburlNamespace.com/"; //this must match what is in your .net web service code
	self.ServerURL = @"http://yourserviceurl/yourservice.asmx";

	
	DataSet *tmp = [[DataSet alloc] init];
	self.myDataset = tmp;
	[tmp release];
	
	NSOperationQueue *tmpOp = [[NSOperationQueue alloc] init];
	self.opQueue = tmpOp;
	[tmpOp release];
	[self.opQueue setMaxConcurrentOperationCount:1];
	
	return self;
}
-(void)reset
{
	//add any reset code

	[self stopAllProcesses];

}
-(void)stopAllProcesses
{
	
	[self.opQueue cancelAllOperations];
}

-(void)dealloc
{
	[opQueue release];
	[myDataset release];
	[ServerURL release];
	[XMLNamespace release];
	[super dealloc];
}
#pragma mark -
#pragma mark initDownload Methods


-(void)initDownloadMyDataset:(NSString *)param1 Param2:(NSString *)param2
{
	//make sure opqueue is initialized
	if(!self.opQueue) {self.opQueue = [[NSOperationQueue alloc] init];}
	
	//since we have more then one parameter we must add them to an array as the NSInvocationRequest only allows for a single parameter
	NSArray *params = [[NSArray alloc] initWithObjects:param1, param2, nil];
	//call our delegate function so we know the call will start downloading
	[delegate performSelectorOnMainThread:@selector(willStartDownloading:)
							   withObject:self
							waitUntilDone:NO];
	//create async request
	NSInvocationOperation *request = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getMyDataset:) object:params];
	[self.opQueue addOperation:request];
	[request release];
	[params release];
}
#pragma mark -
#pragma mark Download Work Methods
-(void)getMyDataset:(NSArray *)params
{

	NSString *param1 = [params objectAtIndex:0];
	NSString *param2 = [params objectAtIndex:1];

	// Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *DataCon = [[WebServiceHelper alloc] init];
	//set up service method and urls
	DataCon.XMLNameSpace = self.XMLNamespace;
	DataCon.XMLURLAddress = self.ServerURL;
	
	//set up method and parameters
	DataCon.MethodName = @"getMyDataset";
	
	
	DataCon.MethodParameters = [[NSMutableDictionary alloc] init];
	[DataCon.MethodParameters setObject:param1 forKey:@"param1"];
	[DataCon.MethodParameters setObject:param2 forKey:@"param2"];

	NSMutableData *retData;
	retData = [DataCon initiateConnection];

	//self.myDataset.doDebug = YES; //uncomment to print all data to NSLog
	[self.myDataset parseXMLWithData:retData];
					 
	[DataCon release];
	
	//call delegate to let view know we have finished downloading this
	[delegate performSelectorOnMainThread:@selector(didFinishDownloading:)
							   withObject:self
							waitUntilDone:NO];
	
}
@end
