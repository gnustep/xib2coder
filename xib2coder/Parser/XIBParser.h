//
//  XIBParser.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import <Foundation/NSObject.h>
#import <Foundation/NSXMLParser.h>

#import "XIBAbstractCodeGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@class NSString, NSMutableArray, NSMutableDictionary;

@interface XIBParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *stack;
@property (nonatomic, retain) NSMutableDictionary *objectDictionary;
@property (nonatomic, retain) NSString *targetRuntime;

@property (nonatomic, assign) NSUInteger kindex;

- (instancetype) initWithString: (NSString *)document;
- (instancetype) initWithData: (NSData *)data;
- (NSDictionary *) parse;

@end

NS_ASSUME_NONNULL_END

