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
#import "XIBObjCCodeBuilder.h"

@implementation XIBObjCClassBuilder

- (instancetype) initWithDictionary:(NSDictionary *)dictionary withTargetRuntime:(nonnull NSString *)runtime
{
    self = [super initWithDictionary: dictionary withTargetRuntime: runtime];
    if (self != nil)
    {
        self.header = @"";
        self.source = @"";
        self.coding = @"";
        self.attributes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSDictionary *) buildClassMap
{
    NSDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                // @"XIBCustomObject", @"NSCustomObject",
                                @"NSNibOutletConnector", @"NSOutlet",
                                @"NSNibControlConnector", @"NSAction",
                                @"NSString", @"NSTaggedPointerString",
                                @"NSString", @"__NSCFConstantString",
                                @"NSString", @"__NSCFString",
                                nil];
    return dictionary;
}

// Class specific
- (NSString *) entityNameForElementName: (NSString *)elementName
{
    NSString *result = @"IBObjectContainer";
    
    if (elementName != nil)
    {
        NSString *prefix = nil;

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
    }

    return result;
}

- (NSString *) typeForEntityValue: (id)o
{
    NSString *typeName = nil;

    if ([o isNumeric])
    {
        if ([o containsString: @"-"])
        {
            typeName = @"NSInteger";
        }
        else if ([o containsString: @"."])
        {
            typeName = @"CGFloat";
        }
        else
        {
            typeName =  @"NSUInteger";
        }
    }
    else
    {
        typeName = NSStringFromClass([o class]);
    }
    
    NSString *newType = [self.classMapping objectForKey: typeName];
    if (newType != nil)
    {
        typeName = newType;
    }
    
    return typeName;
}

// build method...
- (id) build
{
    NSString *elementName = [self.dictionary objectForKey: @"elementName"];
    NSEnumerator *en = [self.dictionary keyEnumerator];
    id k = nil;
    
    // NSLog(@"dictionary = %@", self.dictionary);
    self.type = @"class";
    self.name = [self entityNameForElementName: elementName];
    while ((k = [en nextObject]) != nil)
    {
        if ([self.skippedKeys containsObject: k])
        {
            continue;
        }
        
        id o = [self.dictionary objectForKey: k];
        if ([o isKindOfClass: [NSDictionary class]] == NO)
        {
            NSString *otype = [self typeForEntityValue: o];
            if (otype != nil)
            {
                [self.attributes setObject: otype forKey: k];
            }
            else
            {
                NSLog(@"OType is nil");
            }
        }
        else
        {
            NSString *keyName = [o objectForKey: @"key"];
            if (keyName != nil) // object
            {
                NSString *elemName = [o objectForKey: @"elementName"];
                NSString *clzName = [self entityNameForElementName: elemName];
                [self.attributes setObject: clzName forKey: keyName];
            }
            else // struct
            {
                NSString *elemName = [o objectForKey: @"elementName"];
                NSString *clzName = [self entityNameForElementName: elemName];
                [self.attributes setObject: clzName forKey: k];
            }
            
            XIBObjCClassBuilder *builder = [[XIBObjCClassBuilder alloc] initWithDictionary: o withTargetRuntime: self.runtime];
            builder.codeBuilder = self.codeBuilder;
            [builder build];
            
            [builder.codeBuilder addBuiltClass: builder];
        }
    }
    
    return self;
}

- (id) copyWithZone:(NSZone *)zone
{
    XIBObjCClassBuilder *obj = [[XIBObjCClassBuilder alloc] initWithDictionary: self.dictionary
                                                             withTargetRuntime: [self.runtime copyWithZone: zone]];

    obj.attributes = [self.attributes copyWithZone: zone];
    obj.header = [self.header copyWithZone: zone];
    obj.source = [self.source copyWithZone: zone];
    
    return obj;
}

- (NSDictionary *) dictionaryRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys: self.name, self.type, self.attributes,
            @"name", @"type", @"attributes", nil];
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"<%@> - name = %@, type = %@, attributes = %@", [super description], self.name, self.type, self.attributes]; // , [self dictionaryRepresentation]];
}
@end
