//  DataSet.m
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.

#import "DataSet.h"
#import "XMLDataSetParser.h"

@implementation DataSet
@synthesize Tables;
@synthesize DataSetName;
@synthesize doDebug;
@synthesize xmParser;

-(id) init
{
	XmlDataSetParser *tmXmParser = [[XmlDataSetParser  alloc] init];
	self.xmParser = tmXmParser;
	[tmXmParser release];
	return self;
	
}
-(void)removeAllObjects
{
	self.DataSetName = @"";
	self.xmParser.DataSetName = nil;
	self.xmParser.beginDataset = NO;
	self.xmParser.currentRow  = @"0";

	//clear tables
	NSEnumerator *tblIterator = [self.Tables keyEnumerator];
	NSString *tblKey;
	while(tblKey = [tblIterator nextObject])
	{
		NSMutableDictionary *thisTbl = [self.Tables objectForKey:tblKey];
		NSEnumerator *rowIterator = [thisTbl keyEnumerator];
		NSString *rowKey;
		while (rowKey = [rowIterator nextObject]) {
			NSMutableDictionary *thisRow = [thisTbl objectForKey:rowKey];
			NSArray *allKeys = [[NSArray alloc] initWithArray:[thisRow allKeys]];
			NSUInteger i;
			for(i=0;i<[allKeys count];i++)
			{
				[thisRow setObject:@"" forKey:[allKeys objectAtIndex:i]];
				//NSLog(@"thisRowValue:%@ thisKey:%@", [thisRow objectForKey:[allKeys objectAtIndex:i]], [allKeys objectAtIndex:i], nil);
			}
			
			[allKeys release];
			[thisRow removeAllObjects];
			
		}
		[thisTbl removeAllObjects];
	}

	[self.Tables removeAllObjects];
	NSLog(@"TableCount:%d", [self.Tables count],nil);
}
-(void)parseXMLWithData:(NSMutableData *)data
{
	//reset my own data
	[self removeAllObjects];
	//encode rawdata from httprequest to string for debugging
	if(self.doDebug)
	{
		NSString *theXml = [[NSString alloc] initWithBytes:[data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
		NSLog(@"response:%@", theXml, nil);
		[theXml release];
	}
	
	// Create the XML Parser Objects
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    // Set XMLParser as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	
    [parser setDelegate:self.xmParser];
    // Set Parser Options
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    // Begin parsing the XML
	xmParser.beginTable = NO;
	xmParser.beginDataset = NO;
	xmParser.currentRow = @"0";
	
    [parser parse];
	
	self.Tables = self.xmParser.Tables;
	self.DataSetName = self.xmParser.DataSetName;
	
	//NSLog(@"%@", self.Tables, nil);
	[parser release]; 
}
-(NSMutableDictionary *)getRowsForTable:(NSString *)tableName
{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:[self.Tables objectForKey:tableName]] ;

	if ([returnDictionary count] > 0)
	{
		//there was data return the array else return nil
		return returnDictionary;
	}
	else
	{
		return nil;
	}
		

}
-(NSMutableArray *)getRowsForTableWhereColumnEquals:(NSString *)tableName Column:(NSString *)col Where:(NSString *)where
{
	
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *tbl = [[NSMutableDictionary alloc] initWithDictionary:[self.Tables objectForKey:tableName]];
	
	NSEnumerator *tblIterator = [tbl keyEnumerator];
	NSString *tblKey;
	
	//loop through array
	while(tblKey = [tblIterator nextObject])
	{
		
		NSMutableDictionary *thisRow = [tbl objectForKey:tblKey];
		if([(NSString *)[thisRow objectForKey:col] isEqualToString:where])[returnArray addObject:thisRow];
		
	}	
	[tbl release];
	if ([returnArray count] == 0)
	{
		//there was data return the array else return nil
		returnArray = nil;
	}
	
	return returnArray;
	
	
}
/*
-(NSMutableDictionary *)getRowsForTableAndColumn:(NSString *)tableName col:(NSString *)colName
{
	NSMutableDictionary *returnDictionary = [[[NSMutableDictionary alloc] init] autorelease];

			
			NSMutableDictionary *tbl = [self.Tables objectForKey:tableName];
			NSMutableDictionary *col = [tbl objectForKey:colName];
			returnDictionary = col;
			[col release];
				
	
		if ([returnDictionary count] > 0)
		{
			//there was data return the array else return nil
			return returnDictionary;
		}
		else
		{
			return nil;
		}
		
	
}

-(NSMutableDictionary *)getRowsForTableAndColumnWhereEqualsStrings:(NSString *)tableName col:(NSString *)colName where:(NSArray *)wherevalues
{
	//TODO	
	return nil;
}
//can use if searching same column that is beign returned
-(NSMutableDictionary *)getRowsForTableAndColumnWhereEqualsString:(NSString *)tableName col:(NSString *)colName where:(NSString *)wherevalue
{
	NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
	NSEnumerator *tableIterator = [self.Tables keyEnumerator];
	NSString *tableKey;
	
	
	while(tableKey = [tableIterator nextObject])
	{
		NSLog(@"Table: %@", tableKey);
		
		if([tableKey isEqualToString:tableName])
		{
			//found table get columns
			NSMutableArray *sortedKeys = [NSMutableArray arrayWithArray: [[self.Tables objectForKey:tableKey] allKeys]];
			[sortedKeys sortUsingSelector:@selector(compare:)];
			
			
			NSEnumerator *rowIterator = [sortedKeys objectEnumerator];
			NSString *rowKey;
			
			while(rowKey = [rowIterator nextObject])
			{
				//check if column name matches this nodes column
				if([rowKey rangeOfString:colName].location != NSNotFound)
				{
					
					NSArray *split = [rowKey componentsSeparatedByString:@"--"];
					NSString *rowData = [[self.Tables objectForKey:tableKey] objectForKey:rowKey];
					if ([rowData isEqualToString:wherevalue])
					{
						[returnDictionary setObject:rowData forKey:[split objectAtIndex:1]];
					}
					
				}
			}
		}
	}

	if ([returnDictionary count] > 0)
	{
		//there was data return the array else return nil
		return returnDictionary;
	}
	else
	{
		return nil;
	}
	
	[returnDictionary release];
}
-(NSMutableDictionary *)getRowsForTableAndColumnWhereColumnEqualsString:(NSString *)tableName col:(NSString *)colName whereColumn:(NSString *)wherecolumn whereValue:(NSString *)wherevalue
{
	NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
	NSEnumerator *tableIterator = [self.Tables keyEnumerator];
	NSString *tableKey;
	
	
	while(tableKey = [tableIterator nextObject])
	{
		
		
		if([tableKey isEqualToString:tableName])
		{
			NSLog(@"Table: %@", tableKey);
			//found table get columns
			NSMutableArray *sortedKeys = [NSMutableArray arrayWithArray: [[self.Tables objectForKey:tableKey] allKeys]];
	
			[sortedKeys sortUsingSelector:@selector(compare:)];
	
			NSEnumerator *rowIteratorWhereColumn = [sortedKeys objectEnumerator];
			NSString *rowWhereKey;
			while(rowWhereKey = [rowIteratorWhereColumn nextObject])
			{
				//check if where column name matches this nodes column
				if([rowWhereKey rangeOfString:wherecolumn].location != NSNotFound)
				{
					//get ROW ID number
					NSArray *split = [rowWhereKey componentsSeparatedByString:@"--"];
					//add the matching return column to the return dictionary object
					NSString *coldata = [[self.Tables objectForKey:tableKey] objectForKey:rowWhereKey];
					
					if([coldata isEqualToString:wherevalue])
					{
						[returnDictionary setObject:[[self.Tables objectForKey:tableKey] objectForKey:[NSString stringWithFormat:@"%@--%@", colName, [split objectAtIndex:1]]] forKey:[split objectAtIndex:1]]; 
						//NSLog(@"Row: %@ RetColumn: %@ Data:%@ WhereCol: %@ WhereValue: %@", [split objectAtIndex:1], colName, [[self.Tables objectForKey:tableKey] objectForKey:[NSString stringWithFormat:@"%@--%@", colName, [split objectAtIndex:1]]], wherecolumn, wherevalue);
					}
				}
			}
		}
	}
	
	if ([returnDictionary count] > 0)
	{
		//there was data return the array else return nil
		return returnDictionary;
	}
	else
	{
		return nil;
	}
	
	[returnDictionary release];
}
*/
-(void)dealloc
{
	[xmParser release];
	[DataSetName release];
	[super dealloc];
	
}

@end
