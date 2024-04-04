//
//  XIBObjCCodeBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import "XIBObjCCodeBuilder.h"
#import "XIBObjCClassBuilder.h"

@implementation XIBObjCCodeBuilder

+ (void) initialize
{
    if (nil == __skippedKeys)
    {
        __skippedKeys = [NSArray arrayWithObjects: @"elementName", @"_ordered",
                         @"customClass", @"connections", nil];
    }
}

- (instancetype) initWithDictionary: (NSDictionary *)dictionary
{
    self = [super initWithDictionary: dictionary];
    if (self != nil)
    {
        NSDictionary *objects = [self.dictionary objectForKey: @"objects"];
        self.dictionary = objects;
    }
    return self;
}

- (BOOL) build
{
    NSEnumerator *en = [self.dictionary keyEnumerator];
    id k = nil;
    
    while((k = [en nextObject]) != nil)
    {
        if ([__skippedKeys containsObject: k])
        {
            continue;
        }
        else
        {
            id o = [self.dictionary objectForKey: k];
            if(o != nil)
            {
                XIBObjCClassBuilder *builder = [[XIBObjCClassBuilder alloc] initWithDictionary: o];
                if (NO == [builder build])
                {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}
@end
