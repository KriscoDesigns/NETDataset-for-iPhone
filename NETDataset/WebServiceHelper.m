// WebServiceHelper.m
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.

#import "WebServiceHelper.h"
#import "XmlDataSetParser.h"

@implementation WebServiceHelper
@synthesize MethodName;
@synthesize MethodParameters;
@synthesize XMLNameSpace;
@synthesize XMLURLAddress;
@synthesize SOAPActionURL;
@synthesize MethodParametersAsString;


- (NSMutableData*)initiateConnection
{
	
	NSString *lastChar;
	NSString *slashUsed;
	lastChar = [self.XMLNameSpace substringFromIndex:self.XMLNameSpace.length -1];
	
	if([lastChar isEqualToString:@"/"]){
			slashUsed = @"";
		}
		else
		{
			slashUsed = @"/";
		
		}
	NSMutableString *sRequest = [[NSMutableString alloc] init];
	self.SOAPActionURL = [NSString stringWithFormat:@"%@%@%@",self.XMLNameSpace, slashUsed, self.MethodName];

    //make soap request 
	[sRequest appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[sRequest appendString:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
	[sRequest appendString:@"<soap:Body>"];
	[sRequest appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\">",MethodName, XMLNameSpace]];
	if(MethodParametersAsString != nil) [sRequest appendString:MethodParametersAsString];

	NSEnumerator *tableIterator = [MethodParameters keyEnumerator];
	NSString *keyID;
	while(keyID = [tableIterator nextObject])
	{
		[sRequest appendString:[NSString stringWithFormat:@"<%@>%@</%@>", keyID, [MethodParameters objectForKey:keyID], keyID]];
		NSLog(@"Method: %@ Parameter:%@ Value:%@",self.MethodName, keyID, [MethodParameters objectForKey:keyID], [NSString stringWithFormat:@"<%@>%@</%@>", keyID, [MethodParameters objectForKey:keyID], keyID]);
	}

	//close envelope
	[sRequest appendString:[NSString stringWithFormat:@"</%@>", MethodName]];
	[sRequest appendString:@"</soap:Body>"];
	[sRequest appendString:@"</soap:Envelope>"];
	//NSLog(sRequest);
	//The URL of the Webserver
   	NSURL *myWebserverURL = [NSURL URLWithString:XMLURLAddress];
    // Use the private method setAllowsAnyHTTPSCertificate:forHost:
    // to not validate the HTTPS certificate.  This is used if you are using a testing environment and have
    // a sample SSL certificate set up
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[myWebserverURL host]]; //TODO this can be used for testing only app will get rejected also remove this line before you submit to apple.
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL];
    // Add the Required WCF Header Values.  This is what the WCF service expects in the header.
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.SOAPActionURL forHTTPHeaderField:@"SOAPAction"];
	// Set the action to Post
    [request setHTTPMethod:@"POST"];
    // Set the body
    [request setHTTPBody:[sRequest dataUsingEncoding:NSUTF8StringEncoding]];
	[sRequest release];
   	
	NSError *WSerror;
	NSURLResponse *WSresponse;
	// Call the xml service and return response into a MutableData object
	NSMutableData *myMutableData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&WSresponse error:&WSerror];
	if (WSerror) {
		NSLog(@"Connection Error: %@", [WSerror description], nil);
	}
	return myMutableData;
	
	
} 
-(void)dealloc
{
	[MethodName release];
	[MethodParameters release];
	[XMLNameSpace release];
	[XMLURLAddress release];
	[SOAPActionURL release];
	[MethodParametersAsString release];
	[super dealloc];
}
@end
