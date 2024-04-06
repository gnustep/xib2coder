//
//  XIBObjCClassBuilder.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/NSObject.h>
#import "XIBAbstractBuilder.h"

@class NSString;
@class NSMutableDictionary;

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCClassBuilder : XIBAbstractBuilder <NSCopying>

@property (retain) NSString *className;
@property (retain) NSMutableDictionary *attributes;

@property (retain) NSString *header;
@property (retain) NSString *source;
@property (retain) NSString *coding;

- (NSString *) typeForEntityValue: (id)o;

@end

NS_ASSUME_NONNULL_END
