//
//  XIBClassGenerator.h
//  xib2coder
//
//  Created by Gregory John Casamento on 4/12/24.
//

#import <Foundation/NSObject.h>

@class NSString;
@class NSDictionary;

NS_ASSUME_NONNULL_BEGIN

@interface XIBClassGenerator : NSObject

@property (retain) NSDictionary *dictionary;
@property (retain) NSString *fileName;

- (instancetype) initWithDictionary: (NSDictionary *)dict fileName: (NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
