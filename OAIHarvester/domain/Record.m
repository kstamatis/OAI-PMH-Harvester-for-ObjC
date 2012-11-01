/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import "Record.h"

@implementation Record

@synthesize recordMetadata, recordHeader;

#pragma mark - Initialization Methods
- (id) initWithXMLElement:(CXMLElement *)recordXMLElement{
    if (self = [super init]){
        CXMLElement *headerElement = [[recordXMLElement elementsForLocalName:@"header" URI:@"http://www.openarchives.org/OAI/2.0/"] objectAtIndex:0];
        CXMLElement *metadataElement = [[recordXMLElement elementsForLocalName:@"metadata" URI:@"http://www.openarchives.org/OAI/2.0/"] objectAtIndex:0];
        self.recordMetadata = [[[RecordMetadata alloc] initWithXMLElement:metadataElement] autorelease];
        self.recordHeader = [[[RecordHeader alloc] initWithXMLElement:headerElement] autorelease];
    }
    return self;
}

#pragma mark - Memory Management
- (void) dealloc {
    
    [recordMetadata release];
    
    [super dealloc];
}

@end
