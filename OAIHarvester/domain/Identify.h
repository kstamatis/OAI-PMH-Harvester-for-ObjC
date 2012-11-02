//
//  Identify.h
//  OAIHarvesterExample
//
//  Created by Kostas Stamatis on 11/2/12.
//  Copyright (c) 2012 Kostas Stamatis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NO_DELETION = 0,
	PERSISTENT_DELETION,
    TRANSIENT_DELETION,
    OTHER
    
} DELETIONS_STATUS;

@interface Identify : NSObject {
    NSString *repositoryName;
    NSString *baseURL;
    NSString *protocolVersion;
    NSString *earliestDatestamp;
    NSString *granularity;
    
    DELETIONS_STATUS deletionStatus;
    
    NSMutableArray *adminEmails;
    NSMutableArray *compressions;
    NSMutableArray *descriptions;
}

@property (nonatomic, retain) NSString *repositoryName;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *protocolVersion;
@property (nonatomic, retain) NSString *earliestDatestamp;
@property (nonatomic, retain) NSString *granularity;
@property (nonatomic, assign) DELETIONS_STATUS deletionStatus;
@property (nonatomic, retain) NSMutableArray *adminEmails;
@property (nonatomic, retain) NSMutableArray *compressions;
@property (nonatomic, retain) NSMutableArray *descriptions;

#pragma mark - Initialization Methods
- (id) initWithXMLElement:(CXMLElement *)xmlElement;

@end
