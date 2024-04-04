//
//  XIBObjCCodeBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import "XIBObjCCodeBuilder.h"

@implementation XIBObjCCodeBuilder

- (instancetype) initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        self.dictionary = dictionary;
    }
    
    return self;;
}

- (BOOL) build
{
    return NO;
}

@end
