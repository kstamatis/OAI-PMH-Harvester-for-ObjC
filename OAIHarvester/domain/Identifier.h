/*********************************************************************************************
 
 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
 
**********************************************************************************************/

#import <Foundation/Foundation.h>

@interface Identifier : NSObject {
    NSString *identifier;
    NSString *datestamp;
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *datestamp;

#pragma mark Initialization Methods
- (id) initWithXMLElement:(CXMLElement *)xmlElement;

@end
