//
//  ResumptionToken.h
//  OAIHarvesterExample
//
//  Created by Kostas Stamatis on 11/3/12.
//  Copyright (c) 2012 Kostas Stamatis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumptionToken : NSObject {
    
    NSString *expireDate;
    NSString *token;
    int completeListSize;
    int cursor;
    
}

@property (nonatomic, retain) NSString *expireDate;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) int completeListSize;
@property (nonatomic, assign) int cursor;

#pragma mark Initialization Methods
- (id) initWithXMLElement:(CXMLElement *)xmlElement;

@end
