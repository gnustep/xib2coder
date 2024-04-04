//
//  XIBObjCClassBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/Foundation.h>

#import "XIBAbstractBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCClassBuilder : XIBAbstractBuilder

@property (retain) NSString *header;
@property (retain) NSString *source;

@end

NS_ASSUME_NONNULL_END
