//
//  XIBObjCCodeBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import <Foundation/Foundation.h>

#import "XIBAbstractBuilder.h"

@class XIBObjCClassBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCCodeBuilder : XIBAbstractBuilder

@property (retain) NSMutableDictionary *resultsDictionary;

- (void) addBuiltClass: (XIBObjCClassBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
