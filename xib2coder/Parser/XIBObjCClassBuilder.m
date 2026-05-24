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
    NSString *typeName = NSStringFromClass([o class]);
    
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
    else if ([o containsString: @"YES"] || [o containsString: @"NO"])
    {
        typeName = @"BOOL";
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

- (NSDictionary *) dictionaryForIdentifier: (NSString *)identifier inDictionary: (NSDictionary *)dictionary
{
    NSEnumerator *en = [dictionary keyEnumerator];
    id k = nil;

    if (identifier == nil || dictionary == nil)
    {
        return nil;
    }

    id directMatch = [dictionary objectForKey: identifier];
    if ([directMatch isKindOfClass: [NSDictionary class]])
    {
        return directMatch;
    }

    while ((k = [en nextObject]) != nil)
    {
        id value = [dictionary objectForKey: k];
        NSDictionary *match = nil;

        if ([value isKindOfClass: [NSDictionary class]] == NO)
        {
            continue;
        }

        match = [self dictionaryForIdentifier: identifier inDictionary: value];
        if (match != nil)
        {
            return match;
        }
    }

    return nil;
}

- (NSString *) typeForObjectDictionary: (NSDictionary *)dictionary
{
    NSString *elemName = [dictionary objectForKey: @"elementName"];
    NSString *clzName = [dictionary objectForKey: @"customClass"];

    if (clzName == nil || [clzName length] == 0)
    {
        clzName = [self entityNameForElementName: elemName];
    }

    return clzName;
}

- (NSString *) typeForConnectionDestination: (NSString *)destination
{
    NSDictionary *destinationDictionary = [self dictionaryForIdentifier: destination
                                                           inDictionary: self.codeBuilder.dictionary];

    if (destinationDictionary == nil)
    {
        return @"id";
    }

    return [self typeForObjectDictionary: destinationDictionary];
}

- (void) addOutletAttributesFromConnectionsDictionary: (NSDictionary *)dictionary
{
    NSEnumerator *en = [dictionary keyEnumerator];
    id k = nil;

    while ((k = [en nextObject]) != nil)
    {
        id value = [dictionary objectForKey: k];
        NSString *elementName = nil;

        if ([value isKindOfClass: [NSDictionary class]] == NO)
        {
            continue;
        }

        elementName = [value objectForKey: @"elementName"];
        if ([elementName isEqualToString: @"outlet"])
        {
            NSString *property = [value objectForKey: @"property"];
            NSString *destination = [value objectForKey: @"destination"];

            if (property != nil && [property length] > 0)
            {
                [self.attributes setObject: [self typeForConnectionDestination: destination]
                                    forKey: property];
            }
        }
        else
        {
            [self addOutletAttributesFromConnectionsDictionary: value];
        }
    }
}

// build method...
- (id) build
{
    NSString *elementName = [self.dictionary objectForKey: @"elementName"];
    NSEnumerator *en = [self.dictionary keyEnumerator];
    id k = nil;
    
    // NSLog(@"dictionary = %@", self.dictionary);
    self.type = @"class";
    self.name = [self.dictionary objectForKey: @"customClass"];
    if (self.name == nil || [self.name length] == 0)
    {
        self.name = [self entityNameForElementName: elementName];
    }
    
    if (NULL == NSClassFromString(self.name))
    {
        // NSLog(@"name = %@", self.name);
        self.type = @"primitive";
    }
    
    while ((k = [en nextObject]) != nil)
    {
        if ([k isEqualToString: @"connections"])
        {
            [self addOutletAttributesFromConnectionsDictionary: [self.dictionary objectForKey: k]];
            continue;
        }

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
                NSString *clzName = [o objectForKey: @"customClass"];

                if (clzName == nil || [clzName length] == 0)
                {
                    clzName = [self entityNameForElementName: elemName];
                }

                [self.attributes setObject: clzName forKey: keyName];
            }
            else // struct
            {
                [self.attributes setObject: [self typeForObjectDictionary: o] forKey: k];
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
