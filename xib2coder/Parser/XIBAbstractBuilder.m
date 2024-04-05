//
//  XIBAbstractBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>

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
        self.classMapping = [self buildClassMap];
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
        self.classMapping = [self buildClassMap];
        NSLog(@"Dictionary = %@", self.dictionary);
    }
    
    return self;
}

- (NSDictionary *) buildClassMap
{
    return [NSDictionary dictionary];
}

- (BOOL) build
{
    return NO;
}

@end
