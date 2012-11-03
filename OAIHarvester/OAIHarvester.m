/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import "OAIHarvester.h"

@interface OAIHarvester ()

- (void) checkResponseForError:(CXMLElement *)oaiPmhElement withError:(NSError **)error;
- (NSArray *)listRecordsWithResumptionToken:(NSString *)resumptionTkn fetchAll:(BOOL)fetchAll error:(NSError **)error;

@end


@implementation OAIHarvester

@synthesize metadataPrefix, setSpec, baseURL, resumptionToken;
@synthesize identify, metadataFormats, sets, records;

#pragma mark - Initialization Methods
- (id) init{
    if (self = [super init]){
        
        self.resumptionToken = nil;
        self.identify = nil;
        self.metadataFormats = nil;
        self.sets = nil;
    }
    return self;
}

- (id) initWithBaseURL:(NSString *)theBaseURL{
    if (self = [super init]){
        
        self.resumptionToken = nil;
        self.identify = nil;
        self.metadataFormats = nil;
        self.sets = nil;
        
        self.baseURL = theBaseURL;
        
    }
    return self;
}

#pragma mark - Setters
- (void) setBaseURL:(NSString *)theBaseURL {
    baseURL = [theBaseURL retain];
    [self identifyWithError:nil];
    [self listMetadataFormatsWithError:nil];
    [self listSetsWithError:nil];
}

#pragma mark - Error Checking
- (void) checkResponseForError:(CXMLElement *)oaiPmhElement withError:(NSError **)error{
    NSDictionary *namespaceMappings = [NSDictionary dictionaryWithObject:BASE_NAMESPACE forKey:@"oai-pmh"];
    
    NSError *err = nil;
    NSArray *errors = [oaiPmhElement nodesForXPath:@"//oai-pmh:error" namespaceMappings:namespaceMappings error:&err];
    if (!err && [errors count]>0){
        CXMLElement *errorElement = [errors objectAtIndex:0];
        NSString *code = [[[errorElement attributeForName:@"code"] stringValue] retain];
        HarvesterError *harvesterError = [[[HarvesterError alloc] initWithDomain:[NSString stringWithFormat:@"harvester.oaipmh.error.%@", code] code:0 userInfo:nil] autorelease];
        *error = harvesterError;
    }
    else {
        *error = err;
    }
}

#pragma mark - Verbs
- (BOOL) hasNextRecords {
    if (self.resumptionToken){
        return YES;
    }
    
    return NO;
}

- (NSArray *) getNextRecordsWithError:(NSError **)error {
    if (self.resumptionToken){
        return [self listRecordsWithResumptionToken:self.resumptionToken.token error:error];
    }
    
    return [self listRecordsWithResumptionToken:nil error:error];
}

- (NSArray *)listAllRecordsWithError:(NSError **)error{
    return [self listRecordsWithResumptionToken:nil fetchAll:YES error:error];
}

- (NSArray *)listRecordsWithResumptionToken:(NSString *)resumptionTkn error:(NSError **)error{
    return [self listRecordsWithResumptionToken:resumptionTkn fetchAll:NO error:error];
}

- (NSArray *)listRecordsWithResumptionToken:(NSString *)resumptionTkn fetchAll:(BOOL)fetchAll error:(NSError **)error{
    
    if (!baseURL){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nobaseurl" code:0 userInfo:nil];
        return nil;
    }
    
    if (!metadataPrefix){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nometadataprefix" code:0 userInfo:nil];
        return nil;
    }
    
    NSURL *url;
    
    if (!resumptionTkn)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=ListRecords&metadataPrefix=%@",baseURL, metadataPrefix]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=ListRecords&resumptionToken=%@",baseURL, resumptionTkn]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    
    NSError *err = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (!err){
        CXMLDocument *document = [[[CXMLDocument alloc] initWithData:responseData options:0 error:&err] autorelease];
        if (!err){
            CXMLElement *oaiPmhElement = [document rootElement];
            
            [self checkResponseForError:oaiPmhElement withError:&err];
            if (err){
                *error = err;
                return nil;
            }
            
            NSDictionary *namespaceMappings = [NSDictionary dictionaryWithObject:BASE_NAMESPACE forKey:@"oai-pmh"];
            
            NSArray *resumptionTokens = [oaiPmhElement nodesForXPath:@"//oai-pmh:resumptionToken" namespaceMappings:namespaceMappings error:error];
            if ([resumptionTokens count] > 0){
                NSString *token = [[resumptionTokens objectAtIndex:0] stringValue];
                if (!token || [token isEqualToString:@""]){
                    self.resumptionToken = nil;
                }
                else {
                    //if (self.resumptionToken){
                    //    [self.resumptionToken release];
                    //    self.resumptionToken = nil;
                    //}
                    self.resumptionToken = [[[ResumptionToken alloc] initWithXMLElement:[resumptionTokens objectAtIndex:0]] autorelease];
                    NSLog(@"Token: %@", self.resumptionToken.token);
                }
            }
            else {
                self.resumptionToken = nil;
            }
            
            NSArray *records2 = [oaiPmhElement nodesForXPath:@"//oai-pmh:record" namespaceMappings:namespaceMappings error:error];
            NSMutableArray *results = [[NSMutableArray alloc] init];
            for (CXMLElement *recordNode in records2){
                Record *record = [[Record alloc] initWithXMLElement:recordNode];
                [results addObject:record];
                [record release];
            }
            
            if (fetchAll && self.resumptionToken){
                [results addObjectsFromArray:[self listRecordsWithResumptionToken:self.resumptionToken.token fetchAll:fetchAll error:error]];
            }
            
            //if (self.records){
            //    [self.records release];
            //    self.records = nil;
            //}
            self.records = results;
            
            return [results autorelease];
        }
        *error = err;
        return nil;
    }
    *error = err;
    return nil;
}

- (Identify *)identifyWithError:(NSError **)error{
    
    if (!baseURL){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nobaseurl" code:0 userInfo:nil];
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=Identify",baseURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    
    NSError *err = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (!err){
        CXMLDocument *document = [[[CXMLDocument alloc] initWithData:responseData options:0 error:&err] autorelease];
        if (!err){
            CXMLElement *oaiPmhElement = [document rootElement];
            
            [self checkResponseForError:oaiPmhElement withError:&err];
            if (err){
                *error = err;
                return nil;
            }
            
            NSDictionary *namespaceMappings = [NSDictionary dictionaryWithObject:BASE_NAMESPACE forKey:@"oai-pmh"];
            NSArray *indentifyArray = [oaiPmhElement nodesForXPath:@"//oai-pmh:Identify" namespaceMappings:namespaceMappings error:error];
            
            CXMLElement *identifyNode = [indentifyArray objectAtIndex:0];
            
            Identify *identify2 = [[Identify alloc] initWithXMLElement:identifyNode];
            
            if (self.identify){
                [self.identify release];
                self.identify = nil;
            }
            self.identify = identify2;
            
            return [identify2 autorelease];
        }
        *error = err;
        return nil;
    }
    *error = err;
    return nil;
}

- (NSArray *)listMetadataFormatsWithError:(NSError **)error {
    
    return [self listMetadataFormatsForItem:nil error:error];
}

- (NSArray *)listMetadataFormatsForItem:(NSString *)itemIdentifier error:(NSError **)error {
    if (!baseURL){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nobaseurl" code:0 userInfo:nil];
        return nil;
    }
    
    NSURL *url;
    
    if (!itemIdentifier)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=ListMetadataFormats",baseURL]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=ListMetadataFormats&identifier=%@",baseURL, itemIdentifier]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    
    NSError *err = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (!err){
        CXMLDocument *document = [[[CXMLDocument alloc] initWithData:responseData options:0 error:&err] autorelease];
        if (!err){
            CXMLElement *oaiPmhElement = [document rootElement];
            
            [self checkResponseForError:oaiPmhElement withError:&err];
            if (err){
                *error = err;
                return nil;
            }
            
            NSDictionary *namespaceMappings = [NSDictionary dictionaryWithObject:BASE_NAMESPACE forKey:@"oai-pmh"];
            NSArray *formatArray = [oaiPmhElement nodesForXPath:@"//oai-pmh:metadataFormat" namespaceMappings:namespaceMappings error:error];
            
            NSMutableArray *results = [[NSMutableArray alloc] init];
            for (CXMLElement *formatElement in formatArray){
                MetadataFormat *format = [[MetadataFormat alloc] initWithXMLElement:formatElement];
                [results addObject:format];
                [format release];
            }
            
            if (!itemIdentifier){
                if (self.metadataFormats){
                    [self.metadataFormats release];
                    self.metadataFormats = nil;
                }
                self.metadataFormats = results;
            }
            
            return [results autorelease];
        }
        *error = err;
        return nil;
    }
    *error = err;
    return nil;
}

- (NSArray *)listSetsWithError:(NSError **)error {
    if (!baseURL){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nobaseurl" code:0 userInfo:nil];
        return nil;
    }
    
    NSURL *url;
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=ListSets",baseURL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    
    NSError *err = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (!err){
        CXMLDocument *document = [[[CXMLDocument alloc] initWithData:responseData options:0 error:&err] autorelease];
        if (!err){
            CXMLElement *oaiPmhElement = [document rootElement];
            
            [self checkResponseForError:oaiPmhElement withError:&err];
            if (err){
                *error = err;
                return nil;
            }
            
            NSDictionary *namespaceMappings = [NSDictionary dictionaryWithObject:BASE_NAMESPACE forKey:@"oai-pmh"];
            NSArray *formatArray = [oaiPmhElement nodesForXPath:@"//oai-pmh:set" namespaceMappings:namespaceMappings error:error];
            
            NSMutableArray *allSets = [[NSMutableArray alloc] init];
            for (CXMLElement *setElement in formatArray){
                Set *set = [[Set alloc] initWithXMLElement:setElement];
                [allSets addObject:set];
                [set release];
            }
            
            if (self.sets){
                [self.sets release];
                self.sets = nil;
            }
            self.sets = allSets;
            
            return [allSets autorelease];
        }
        *error = err;
        return nil;
    }
    *error = err;
    return nil;
}

#pragma mark - Memory Management
- (void) dealloc {
    
    [baseURL release];
    [metadataPrefix release];
    [setSpec release];
    
    [resumptionToken release];
    
    [identify release];
    [metadataFormats release];
    [sets release];
    [records release];
    
    [super dealloc];
}

@end
