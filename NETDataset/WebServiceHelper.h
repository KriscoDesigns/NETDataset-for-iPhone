// WebServiceHelper.h
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.
#import <UIKit/UIKit.h>


@interface WebServiceHelper : NSObject {
	NSString *XMLNameSpace;
	NSString *XMLURLAddress;
	NSString *MethodName;
	NSString *SOAPActionURL;
	NSMutableDictionary *MethodParameters;
	NSMutableString *MethodParametersAsString;
}
@property(nonatomic, copy) NSString *XMLNameSpace;
@property(nonatomic, copy) NSString *XMLURLAddress;
@property(nonatomic, copy) NSString *MethodName;
@property(nonatomic, retain) NSMutableDictionary *MethodParameters;
@property(nonatomic, copy) NSString *SOAPActionURL;
@property(nonatomic, retain) NSMutableString *MethodParametersAsString;

- (NSMutableData*)initiateConnection;


@end