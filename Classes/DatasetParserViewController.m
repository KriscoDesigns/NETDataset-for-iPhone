//
//  DatasetParserViewController.m
//  DatasetParser
//
//  Created by Kris Bray on 10-05-27.
//  Copyright 2010 Imperium. All rights reserved.
//

#import "DatasetParserViewController.h"


@implementation DatasetParserViewController
@synthesize data, act;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	cacheDB = [[CacheDBCommands alloc] init];
	cacheDB.delegate = self;
	[cacheDB initDownloadMyDataset:@"param1Value" Param2:@"pram2Value"];
	
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSDictionary *thisRow = [self.data objectAtIndex:row];
	NSString *column1 = [thisRow objectForKey:@"Column1"];

	
   cell.textLabel.text = column1;
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

#pragma mark -
#pragma mark CacheDBCommands Delegate

- (void)willStartDownloading:(CacheDBCommands *)cacheDB
{
	//NSLog(@"Delegate called start downloading", nil);
	[self.act startAnimating];
	self.act.hidden = NO;
}
-(void)didFinishDownloading:(CacheDBCommands *)acacheDB
{
	//NSLog(@"Delegate called finish downloading", nil);
	
	
	
	//clear data
	[self.data removeAllObjects];
	NSMutableDictionary *rows = [[NSMutableDictionary alloc] initWithDictionary:[acacheDB.myDataset getRowsForTable:@"Table1"]];
	
	/*
	//the following shows how to iterate the data manually however it is easier in this case to just use the returned array of rows
	//
	NSEnumerator *rowIterator = [rows keyEnumerator];
	NSString *rowKey;
	
	//loop through downloaded data
	while(rowKey = [rowIterator nextObject])
	{
		NSMutableDictionary *thisRow = [rows objectForKey:rowKey];
		
		NSArray *aRecord = [[NSArray alloc] initWithObjects:[thisRow objectForKey:@"column1"], 
							 [thisRow objectForKey:@"column2"],
							 nil];
		
		[self.data addObject:anExtra];
		[aRecord release];
		
		
	}	
	 */
	
	self.data = [[NSMutableArray alloc] initWithArray:[rows allValues]]; //each object in the array is a dictionary object containing all of the columns and values
	
	[rows release];
	[self.tableView reloadData];
	[self.act stopAnimating];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[data release];
	[act release];
    [super dealloc];
}


@end

