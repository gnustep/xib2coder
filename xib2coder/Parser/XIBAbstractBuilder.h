//
//  XIBAbstractBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/NSObject.h>

NS_ASSUME_NONNULL_BEGIN

@class NSString, NSDictionary, NSArray;

@interface XIBAbstractBuilder : NSObject

@property (retain) NSDictionary *dictionary;
@property (retain) NSString *runtime;
@property (retain) NSDictionary *classMapping;
@property (retain) NSArray *skippedKeys;

- (instancetype) initWithDictionary: (NSDictionary *)dictionary withTargetRuntime: (NSString *)runtime;
- (NSDictionary *) buildClassMap;
- (id) build;

@end

NS_ASSUME_NONNULL_END
