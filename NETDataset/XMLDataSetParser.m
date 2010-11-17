// XMLDataSetParser.m
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.

#import "XmlDataSetParser.h"


@implementation XmlDataSetParser
@synthesize Tables;
@synthesize currentTable;
@synthesize currentColumn,currentRow ;
@synthesize dicCurrentRow;//, currentData;
@synthesize DataSetName;
@synthesize beginDataset, beginTable;
-(id) init
{
	// Init currentdata holder
	currentData  = [[NSMutableString alloc]initWithString:@""];
	
	NSMutableDictionary *thisTblTmp = [[NSMutableDictionary alloc] init];
	self.Tables = thisTblTmp;
	[thisTblTmp release];
	
	
	NSMutableDictionary *dictmpRow = [[NSMutableDictionary alloc] init];
	self.dicCurrentRow  = dictmpRow;
	[dictmpRow release];
	
	beginDataset = NO;
	self.currentRow  = @"0";
	
	return self;
}
#pragma XML Parser Delegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"Document Started Parsing...");
	
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"Document Ended Parsing...");
	
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	//NSLog(@"found this element: %@", elementName);
	if (beginDataset == YES)
	{
		//add name fo our new dataset 
		self.DataSetName = elementName;
		beginDataset = NO;
	}
	else
	{
		
		if ([elementName isEqualToString:@"diffgr:diffgram"]) {
			//begin recieving the dataset information
			beginDataset = YES;
		}
		
		if (self.DataSetName != nil && beginTable == YES)
		{
			
			//Dataset Started Table Started this must be a column! since value will be handled at delegate method foundcharacters we must add the string value key pair there
			if([self.currentColumn isEqualToString:@""] || self.currentColumn == nil) //check if current column is empty because it should always be empty before assigning a new column, this is reset in the end element
			{
				self.currentColumn = elementName;
				
				//check if the current column exists in the current row, if it does then a new row needs to be created.
				//if the current column does not exist then we simply add a new col / val to the current row
				/*
				if(!self.dicCurrentRow){
					NSMutableDictionary *dictmpRow = [[NSMutableDictionary alloc] init];
					self.dicCurrentRow  = dictmpRow;
					[dictmpRow release];
				}
				 */
				if ([self.dicCurrentRow  objectForKey:self.currentColumn])
				{
					
					//self.dicCurrentRow  = [[NSMutableDictionary alloc] init];
					NSMutableDictionary *tbl = [self.Tables objectForKey:self.currentTable];
					self.currentRow  = [NSString stringWithFormat:@"%d", [[tbl allKeys] count], nil];
					//NSLog(@"self.currentRow  > %d %@",[[[self.Tables objectForKey:self.currentTable] allKeys] count], self.currentRow , nil);
				}
				
				
				
			}
		}
		if (self.DataSetName != nil && beginTable == NO)
		{
			//dsgroup contains a dataset we can now add a new table if it does not currently exist
			if([self.Tables objectForKey:elementName] == nil)
			{
				NSMutableDictionary *newTable = [[NSMutableDictionary alloc] init];
				[self.Tables setObject:newTable forKey:elementName];
				[newTable release];
				self.currentTable = elementName; 
				
			}
			beginTable = YES; //set table started even if it already existed
		}

	}
		
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{    
	//if(![elementName isEqualToString:@"ImageData"]) NSLog(@"ended element: %@ currentCol:%@ currentVal:%@", elementName, self.currentColumn, currentData, nil);
	if(beginTable == YES && [elementName isEqualToString:self.currentTable])
	{
		//This appears to be the end of a row now not the table
		
		//NSLog(@"%@",self.dicCurrentRow, nil);
		NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:self.dicCurrentRow];
		NSMutableDictionary *tbl = [self.Tables objectForKey:self.currentTable];
		//NSLog(@"%@ rowCount:%d",[newDic objectForKey:@"StyleCategoryId"], [tbl count], nil);
		
		[tbl setObject:newDic forKey:self.currentRow ];
		[newDic release];
		
		//tbl = nil;
		
		//reset row to nothing/new row
		NSArray *allKeys = [[NSArray alloc] initWithArray:[self.dicCurrentRow allKeys]];
		NSUInteger i;
		for(i=0;i<[allKeys count];i++)
		{
			[self.dicCurrentRow setObject:@"" forKey:[allKeys objectAtIndex:i]];
			
		}
		[allKeys release];	
		beginTable = NO;
	}

	if(beginTable == YES && self.currentColumn != @"")
	{
		// Column ended
		NSString *tmp =[[NSString alloc] initWithString:currentData]; // Create copy from nsmutablestring content
		[self.dicCurrentRow setObject:tmp forKey:self.currentColumn];
		[tmp release];
		[currentData setString:@""]; //clear current data
		
		self.currentColumn = @"";
	}
		
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	NSString * errorString = [NSString stringWithFormat:@"Unable to convert XML into dataset: %@", [parseError description]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Contacting Server" message:@"Sorry we can't seem to connect to the server! Please make sure you have an internet connection, or try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[currentData appendString:string];
	
	//NSLog(@"FoundCharacters: ColumnName:%@ currentData:%@ RowID:%@", self.currentColumn, currentData, self.currentRow , nil); 
}
-(void)dealloc
{
	[dicCurrentRow release];
	[DataSetName release];
	[currentRow release];
	[currentTable release];
	[currentColumn release];
	[currentData release];
	[Tables removeAllObjects];
	[Tables release];
	[super dealloc];
}
@end