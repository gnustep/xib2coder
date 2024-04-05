//
//  XIBObjCClassBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

#import "XIBObjCClassBuilder.h"
#import "XIBObjCAccessorBuilder.h"

extern NSArray *__skippedKeys;

@implementation XIBObjCClassBuilder

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary: dictionary];
    if (self != nil)
    {
        self.header = @"";
        self.source = @"";
        self.coding = @"";
    }
    return self;
}

- (BOOL) build
{
    self.className = [self.dictionary objectForKey: @"elementName"];
    
    NSEnumerator *en = [self.dictionary keyEnumerator];
    id k = nil;
    while ((k = [en nextObject]) != nil)
    {
        if ([__skippedKeys containsObject: k])
        {
            continue;
        }
        
        id o = [self.dictionary objectForKey: k];
        XIBObjCAccessorBuilder *builder = [[XIBObjCAccessorBuilder alloc] initWithKey: k andObject: o];
        [builder build];
    }
    
    return YES;
}

@end
