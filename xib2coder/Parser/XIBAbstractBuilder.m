//
//  XIBAbstractBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import "XIBAbstractBuilder.h"

@implementation XIBAbstractBuilder

- (instancetype) initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        self.dictionary = dictionary;
        NSLog(@"Dictionary = %@", self.dictionary);
    }
    
    return self;
}

- (BOOL) build
{
    return NO;
}

@end
