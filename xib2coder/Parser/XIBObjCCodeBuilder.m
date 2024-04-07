//
//  XIBObjCCodeBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import "XIBObjCCodeBuilder.h"
#import "XIBObjCClassBuilder.h"

@implementation XIBObjCCodeBuilder

- (instancetype) initWithDictionary: (NSDictionary *)dictionary withTargetRuntime: (NSString *)runtime
{
    self = [super initWithDictionary: dictionary withTargetRuntime: runtime];
    if (self != nil)
    {
        if ([self.runtime isEqualToString: @"MacOSX.Cocoa"])
        {
            NSDictionary *objects = [self.dictionary objectForKey: @"objects"];
            self.dictionary = [NSDictionary dictionaryWithObject: objects forKey: @"objects"];
            self.resultsDictionary = [NSMutableDictionary dictionary];
        }
        else if ([self.runtime isEqualToString: @"iOS.CocoaTouch"])
        {
            NSDictionary *objects = [self.dictionary objectForKey: @"scenes"];
            self.dictionary = [NSDictionary dictionaryWithObject: objects forKey: @"scenes"];
            self.resultsDictionary = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (id) build
{
    XIBObjCClassBuilder *builder = [[XIBObjCClassBuilder alloc] initWithDictionary: self.dictionary withTargetRuntime: self.runtime];
    builder.codeBuilder = self;
    [builder build];
 
    [self addBuiltClass: builder];
    
    return self;
}

- (NSMutableDictionary *) filterAttributes: (NSDictionary *)attrs
{
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary: attrs];
    NSMutableArray *deleteKeys = [NSMutableArray array];
    NSEnumerator *en = [attrs keyEnumerator];
    NSString *k = nil;
    
    while ((k = [en nextObject]) != nil)
    {
        if ([k containsString: @"-"] || [k containsString: @"_"])
        {
            [deleteKeys addObject: k];
        }
    }
        
    [resultDictionary removeObjectsForKeys: deleteKeys];
    
    return resultDictionary;
}

- (void) addBuiltClass: (XIBObjCClassBuilder *)builder
{
    XIBObjCClassBuilder *b = [self.resultsDictionary objectForKey: builder.name];
    
    if (b == nil)
    {
        builder.attributes = [self filterAttributes: builder.attributes];
        [self.resultsDictionary setObject: builder forKey: builder.name];
    }
    else
    {
        NSDictionary *filteredAttributes = [self filterAttributes: builder.attributes];
        [b.attributes addEntriesFromDictionary: filteredAttributes];
    }
}

@end
