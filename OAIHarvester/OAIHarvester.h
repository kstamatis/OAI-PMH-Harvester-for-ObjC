/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import <Foundation/Foundation.h>
#import "Record.h"
#import "Identify.h"
#import "HarvesterError.h"

#define BASE_NAMESPACE @"http://www.openarchives.org/OAI/2.0/"

@interface OAIHarvester : NSObject {
    
    NSString *baseURL;
    NSString *setSpec;
    NSString *metadataPrefix;
    
    NSString *resumptionToken;
    
    Identify *identify;
}

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *setSpec;
@property (nonatomic, retain) NSString *metadataPrefix;

@property (nonatomic, retain) NSString *resumptionToken;

@property (nonatomic, retain) Identify *identify;

#pragma mark - Initialization Methods
- (id) initWithBaseURL:(NSString *)theBaseURL;

#pragma mark - ListRecords
- (Identify *)identifyWithError:(NSError **)error;
- (NSArray *)listRecordsWithError:(NSError **)error;

@end
