//
//  XIBObjCAccessorBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import "XIBAbstractBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCAccessorBuilder : XIBAbstractBuilder

@property (retain) id key;
@property (retain) id object;

- (instancetype) initWithKey: (id)k andObject: (id)o;

@end

NS_ASSUME_NONNULL_END
