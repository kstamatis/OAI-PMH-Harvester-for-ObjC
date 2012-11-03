//
//  ResumptionToken.m
//  OAIHarvesterExample
//
//  Created by Kostas Stamatis on 11/3/12.
//  Copyright (c) 2012 Kostas Stamatis. All rights reserved.
//

#import "ResumptionToken.h"

@implementation ResumptionToken

@synthesize token, expireDate, completeListSize, cursor;

#pragma mark Initialization Methods
- (id) initWithXMLElement:(CXMLElement *)xmlElement{
    if (self = [super init]){
        
        self.token = [xmlElement stringValue];
        self.expireDate = [[xmlElement attributeForName:@"expirationDate"] stringValue];
        self.cursor = [[[xmlElement attributeForName:@"cursor"] stringValue] intValue];
        self.completeListSize = [[[xmlElement attributeForName:@"completeListSize"] stringValue] intValue];
        
    }
    return self;
}

#pragma mark - Memory Management
- (void) dealloc {
    
    [token release];
    [expireDate release];
    
    [super dealloc];
}
@end
