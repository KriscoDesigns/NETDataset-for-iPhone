// XMLDataSetParser.h
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.

#import <Foundation/Foundation.h>

@interface XmlDataSetParser : NSObject <NSXMLParserDelegate> {
	NSMutableDictionary *Tables;
	BOOL beginDataset;
	BOOL beginTable;
	NSString *currentTable;
	NSString *currentColumn;
	NSString *currentRow;
	NSMutableString *currentData;
	NSMutableDictionary *dicCurrentRow;
	NSString *DataSetName;
}

@property (nonatomic, retain) NSMutableDictionary *Tables;
@property (nonatomic, copy) NSString *currentTable;
@property (nonatomic, copy) NSString *currentColumn;
@property (nonatomic, copy) NSString *currentRow;
//@property (nonatomic, copy) NSMutableString *currentData;
@property (nonatomic, retain) NSMutableDictionary *dicCurrentRow;
@property (nonatomic, retain) NSString *DataSetName;
@property BOOL beginDataset;
@property BOOL beginTable;
- (void)parserDidStartDocument:(NSXMLParser *)parser;
- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end