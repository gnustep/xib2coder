//
//  XIBAbstractBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/NSObject.h>

NS_ASSUME_NONNULL_BEGIN

static NSArray *__skippedKeys = nil;

@class NSString, NSDictionary;

@interface XIBAbstractBuilder : NSObject

@property (retain) NSDictionary *dictionary;
@property (retain) NSString *runtime;
@property (retain) NSDictionary *classMapping;

- (instancetype) initWithDictionary: (NSDictionary *)dictionary;
- (NSDictionary *) buildClassMap;
- (BOOL) build;

@end

NS_ASSUME_NONNULL_END
