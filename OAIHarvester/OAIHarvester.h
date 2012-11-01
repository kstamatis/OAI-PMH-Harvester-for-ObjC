/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import <Foundation/Foundation.h>
#import "Record.h"
#import "HarvesterError.h"

@interface OAIHarvester : NSObject {
    
    NSString *baseURL;
    NSString *setSpec;
    NSString *metadataPrefix;
    
    NSString *resumptionToken;
}

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *setSpec;
@property (nonatomic, retain) NSString *metadataPrefix;

@property (nonatomic, retain) NSString *resumptionToken;

#pragma mark - ListRecords
- (NSArray *)listRecordsWithError:(NSError **)error;

@end
