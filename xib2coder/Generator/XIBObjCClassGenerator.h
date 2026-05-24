//
//  XIBObjCClassGenerator.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/12/24.
//

#import "XIBClassGenerator.h"

@class NSString;

NS_ASSUME_NONNULL_BEGIN

@interface XIBObjCClassGenerator : XIBClassGenerator

@property (retain) NSString *header;
@property (retain) NSString *source;

@end

NS_ASSUME_NONNULL_END
