//
//  XIBAbstractBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import "XIBAbstractBuilder.h"

@implementation XIBAbstractBuilder

+ (void) initialize
{
    if (nil == __skippedKeys)
    {
        __skippedKeys = [NSArray arrayWithObjects: @"elementName", @"_ordered",
                         @"customClass", @"connections", nil];
    }
}

- (instancetype) init
{
    self = [super init];
    if (self != nil)
    {
        // self.dictionary = nil;
    }
    return self;
}

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
