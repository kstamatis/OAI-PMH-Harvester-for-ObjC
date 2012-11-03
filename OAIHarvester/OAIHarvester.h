/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import <Foundation/Foundation.h>

#import "Record.h"
#import "Identify.h"
#import "MetadataFormat.h"
#import "Set.h"
#import "ResumptionToken.h"
#import "HarvesterError.h"

@interface OAIHarvester : NSObject {
    
    NSString *baseURL;
    NSString *setSpec;
    NSString *metadataPrefix;
    
    ResumptionToken *resumptionToken;
    
    Identify *identify;
    NSArray *metadataFormats;
    NSArray *sets;
    NSArray *records;
    
}

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *setSpec;
@property (nonatomic, retain) NSString *metadataPrefix;

@property (nonatomic, retain) ResumptionToken *resumptionToken;

@property (nonatomic, retain) Identify *identify;
@property (nonatomic, retain) NSArray *metadataFormats;
@property (nonatomic, retain) NSArray *sets;
@property (nonatomic, retain) NSArray *records;

#pragma mark - Initialization Methods
- (id) initWithBaseURL:(NSString *)theBaseURL;

#pragma mark - Verbs
- (Identify *)identifyWithError:(NSError **)error;
- (NSArray *)listMetadataFormatsWithError:(NSError **)error;
- (NSArray *)listMetadataFormatsForItem:(NSString *)itemIdentifier error:(NSError **)error;
- (NSArray *)listSetsWithError:(NSError **)error;
- (NSArray *)listAllRecordsWithError:(NSError **)error;
- (NSArray *)listRecordsWithResumptionToken:(NSString *)resumptionTkn error:(NSError **)error;
- (BOOL) hasNextRecords;
- (NSArray *) getNextRecordsWithError:(NSError **)error;

@end
