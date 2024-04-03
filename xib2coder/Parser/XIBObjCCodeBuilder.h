//
//  XIBObjCCodeBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCCodeBuilder : NSObject

- (instancetype) initWithDictionary: (NSDictionary *)dictionary;
- (NSString *) build;

@end

NS_ASSUME_NONNULL_END
