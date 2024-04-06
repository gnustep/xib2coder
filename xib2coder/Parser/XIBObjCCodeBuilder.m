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
        self.dictionary = objects;
        self.resultsDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL) build
{
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
                    return NO;
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
    
    return YES;
}
@end
