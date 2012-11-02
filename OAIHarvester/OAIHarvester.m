/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
 **********************************************************************************************/

#import "OAIHarvester.h"

@interface OAIHarvester ()

- (void) checkResponseForError:(CXMLElement *)oaiPmhElement withError:(NSError **)error;

@end


@implementation OAIHarvester

@synthesize metadataPrefix, setSpec, baseURL, resumptionToken;
@synthesize identify;

#pragma mark - Initialization Methods
- (id) initWithBaseURL:(NSString *)theBaseURL{
    if (self = [super init]){
        
        self.baseURL = theBaseURL;
        
    }
    return self;
}

#pragma mark - Error Checking
- (void) setBaseURL:(NSString *)theBaseURL {
    baseURL = [theBaseURL retain];
    [self identifyWithError:nil];
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

#pragma mark - ListRecords
- (NSArray *)listRecordsWithError:(NSError **)error{
    
    if (!baseURL){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nobaseurl" code:0 userInfo:nil];
        return nil;
    }
    
    if (!metadataPrefix){
        *error = [HarvesterError errorWithDomain:@"harvester.client.error.nometadataprefix" code:0 userInfo:nil];
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?verb=ListRecords&metadataPrefix=%@",baseURL, metadataPrefix]];
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
            NSArray *records = [oaiPmhElement nodesForXPath:@"//oai-pmh:record" namespaceMappings:namespaceMappings error:error];
            NSMutableArray *results = [[NSMutableArray alloc] init];
            for (CXMLElement *recordNode in records){
                Record *record = [[Record alloc] initWithXMLElement:recordNode];
                [results addObject:record];
                [record release];
            }
            
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
            
            self.identify = identify2;
            
            return [identify2 autorelease];
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
    
    [super dealloc];
}

@end
