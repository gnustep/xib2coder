//
//  XIBAbstractBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSException.h>

#import "XIBAbstractBuilder.h"

@implementation XIBAbstractBuilder

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

- (instancetype) initWithDictionary: (NSDictionary *)dictionary withTargetRuntime:(nonnull NSString *)runtime
{
    self = [super init];
    
    if (self != nil)
    {
        NSAssert([dictionary isKindOfClass: [NSDictionary class]], @"Parameter is not a dictionary %@", dictionary);
        self.runtime = runtime;
        self.dictionary = dictionary;
        self.classMapping = [self buildClassMap];
        self.skippedKeys = [self buildSkippedKeys];
    }
    
    return self;
}

- (NSArray *) buildSkippedKeys
{
    return [NSArray arrayWithObjects: @"_ordered", @"elementName", @"key", @"connections", @"rect", nil];
}

- (NSDictionary *) buildClassMap
{
    return [NSDictionary dictionary];
}

- (id) build
{
    return nil;
}

@end
