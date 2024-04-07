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
@class XIBObjCCodeBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCClassBuilder : XIBAbstractBuilder <NSCopying>

@property (retain) NSString *name;
@property (retain) NSMutableDictionary *attributes;
@property (retain) NSString *type;

@property (retain) NSString *header;
@property (retain) NSString *source;
@property (retain) NSString *coding;

@property (retain) XIBObjCCodeBuilder *codeBuilder;

- (NSString *) typeForEntityValue: (id)o;

@end

NS_ASSUME_NONNULL_END
