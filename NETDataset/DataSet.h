//  DataSet.h
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.

#import <Foundation/Foundation.h>
#import "XMLDataSetParser.h"

@interface DataSet : NSObject {
	XmlDataSetParser *xmParser;
	NSString *DataSetName;
	NSMutableDictionary *Tables;
	BOOL doDebug;
}
@property (nonatomic, retain) NSMutableDictionary *Tables;
@property (nonatomic, retain) XmlDataSetParser *xmParser;
@property (nonatomic, copy) NSString *DataSetName;
@property BOOL doDebug;

-(void)parseXMLWithData:(NSMutableData *)data;
-(void)removeAllObjects;
-(NSMutableDictionary *)getRowsForTable:(NSString *)tableName;
-(NSMutableArray *)getRowsForTableWhereColumnEquals:(NSString *)tableName Column:(NSString *)col Where:(NSString *)where;
/*
-(NSMutableDictionary *)getRowsForTableAndColumn:(NSString *)tableName col:(NSString *)colName;
-(NSMutableDictionary *)getRowsForTableAndColumnWhereEqualsString:(NSString *)tableName col:(NSString *)colName where:(NSString *)wherevalue;
-(NSMutableDictionary *)getRowsForTableAndColumnWhereColumnEqualsString:(NSString *)tableName col:(NSString *)colName whereColumn:(NSString *)wherecolumn whereValue:(NSString *)wherevalue;
-(NSMutableDictionary *)getRowsForTableAndColumnWhereEqualsStrings:(NSString *)tableName col:(NSString *)colName where:(NSArray *)wherevalues;
*/
 -(void) dealloc;
@end
