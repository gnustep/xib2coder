//
//  XIBObjCCodeBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import "XIBObjCCodeBuilder.h"
#import "XIBObjCClassBuilder.h"

@implementation XIBObjCCodeBuilder

- (instancetype) initWithDictionary: (NSDictionary *)dictionary
{
    self = [super initWithDictionary: dictionary];
    if (self != nil)
    {
        NSDictionary *objects = [self.dictionary objectForKey: @"objects"];
        self.dictionary = [NSDictionary dictionaryWithObject: objects forKey: @"objects"];
        self.resultsDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id) build
{
    /*
    NSEnumerator *en = [self.dictionary keyEnumerator];
    id k = nil;
    
    while((k = [en nextObject]) != nil)
    {
        if ([self.skippedKeys containsObject: k])
        {
            continue;
        }
        else
        {
            id o = [self.dictionary objectForKey: k];
            if(o != nil)
            {
                XIBObjCClassBuilder *builder = [[XIBObjCClassBuilder alloc] initWithDictionary: o];
                builder.runtime = self.runtime;
                if (NO == [builder build])
                {
                    return nil;
                }
                else
                {
                    XIBObjCClassBuilder *b = [self.resultsDictionary objectForKey: builder.className];
                    if (b == nil)
                    {
                        [self.resultsDictionary setObject: builder forKey: builder.className];
                    }
                    else
                    {
                        [b.attributes addEntriesFromDictionary: builder.attributes];
                    }
                }
            }
        }
    }
    
    NSLog(@"resultsDictionary = %@", self.resultsDictionary);
    
    return self;
    */
    
    XIBObjCClassBuilder *builder = [[XIBObjCClassBuilder alloc] initWithDictionary: self.dictionary];
    builder.runtime = self.runtime;
    builder.codeBuilder = self;
    [builder build];
    
    // NSLog(@"builder = %@", builder);

    [self addBuiltClass: builder];
    
    NSLog(@"resultDictionary = %@", self.resultsDictionary);
    
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
    
    NSLog(@"deleteKeys = %@", deleteKeys);
    
    [resultDictionary removeObjectsForKeys: deleteKeys];
    
    return resultDictionary;
}

- (void) addBuiltClass: (XIBObjCClassBuilder *)builder
{
    XIBObjCClassBuilder *b = [self.resultsDictionary objectForKey: builder.name];

    // NSLog(@"builder = %@", builder);
    
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
