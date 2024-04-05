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
#import "NSString+Additions.h"

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

- (NSString *) entityNameForElementName: (NSString *)elementName
{
    NSString *prefix = nil;
    NSString *result = nil;
    
    if ([self.runtime isEqualToString: @"MacOSX.Cocoa"])
    {
        prefix = @"NS";
    }
    else
    {
        prefix = @"UI";
    }
    
    result = [NSString stringWithFormat: @"%@%@", prefix, [elementName stringByCapitalizingFirstCharacter]];
    NSString *replacement = [self.classMapping objectForKey: result];
    
    if (replacement != nil)
    {
        result = replacement;
    }
    
    return result;
}

- (NSDictionary *) buildClassMap
{
    NSDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"XIBCustomObject", @"NSCustomObject",
                                @"NSNibOutletConnector", @"NSOutlet",
                                @"NSNibControlConnector", @"NSAction",
                                nil];
    return dictionary;
}

- (BOOL) build
{
    NSString *elementName = [self.dictionary objectForKey: @"elementName"];
    NSEnumerator *en = [self.dictionary keyEnumerator];
    id k = nil;
    
    self.className = [self entityNameForElementName: elementName];
    while ((k = [en nextObject]) != nil)
    {
        if ([__skippedKeys containsObject: k])
        {
            continue;
        }
        
        id o = [self.dictionary objectForKey: k];
        if ([o isKindOfClass: [NSDictionary class]] == NO)
        {
            NSString *otype = NSStringFromClass([o class]);
            if (otype != nil)
            {
                [self.attributes setObject: otype forKey: k];
            }
        }
    }
    
    NSLog(@"attrs = %@", self.attributes);
    
    return YES;
}

@end
