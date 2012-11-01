/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import "RecordMetadata.h"

@implementation RecordMetadata

@synthesize metadataElements, namespce, schemaLocation;

#pragma mark Initialization Methods
- (id) initWithXMLElement:(CXMLElement *)metadataXMLElement{
    if (self = [super init]){
        CXMLElement *rootElement = (CXMLElement *)[metadataXMLElement childAtIndex:0];
        
        self.namespce = rootElement.URI;
        self.schemaLocation = [[[rootElement attributeForName:@"schemaLocation"] stringValue] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ", self.namespce] withString:@""];
        
        NSArray *metadataXMLElements = [rootElement children];
        self.metadataElements = [[[NSMutableArray alloc] init] autorelease];
        for (CXMLElement *metadataXMLElement2 in metadataXMLElements){
            MetadataElement *metadataElement = [[MetadataElement alloc] initWithXMLElement:metadataXMLElement2];
            [self.metadataElements addObject:metadataElement];
            [metadataElement release];
        }
    }
    return self;
}

#pragma mark - Memory Management
- (void) dealloc {
    
    [namespce release];
    [schemaLocation release];
    [metadataElements release];
    
    [super dealloc];
}

@end
