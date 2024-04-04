//
//  XIBAbstractBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSArray *__skippedKeys = nil;

@interface XIBAbstractBuilder : NSObject

@property (retain) NSDictionary *dictionary;

- (instancetype) initWithDictionary: (NSDictionary *)dictionary;
- (BOOL) build;

@end

NS_ASSUME_NONNULL_END
