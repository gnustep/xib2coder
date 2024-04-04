//
//  XIBAbstractParserDelegate.m
//  XIBtoCode
//
//  Created by Gregory John Casamento on 11/9/23.
//

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

#import "XIBAbstractCodeGenerator.h"
#import "XIBCustomObject.h"

@implementation XIBAbstractCodeGenerator

- (instancetype) initWithDictionary: (NSDictionary *)dict name: (NSString *)aname
{
    self = [super init];
    if (self != nil)
    {
        self.ownerName = @"";
        self.classMapping = [self buildClassMap];
        self.name = [aname lastPathComponent];
        self.name = [self.name stringByDeletingPathExtension];

        // maps...
        self.idToVar = [NSMutableDictionary dictionary];
        self.varToid = [NSMutableDictionary dictionary];
        self.skippedKeys = [self buildSkippedKeys];
        self.selectorMap = [self buildSelectorMap];
        self.structKeys = [self buildStructKeys];
        
        // objects
        self.objectDictionary = dict;
    }
    return self;
}


- (NSDictionary *) buildClassMap
{
    return [NSDictionary dictionary];
}

- (NSArray *) buildSkippedKeys
{
    return [NSArray arrayWithObjects: @"_ordered", @"elementName", nil];
}

- (NSArray *) buildStructKeys
{
    return [NSArray arrayWithObjects: @"rect", @"point", nil];
}

- (NSDictionary *) buildSelectorMap
{
    return [NSDictionary dictionary];
}

- (BOOL) elementIsAnArray: (NSString *)elementName
{
    NSString *lastChar = [elementName substringFromIndex:[elementName length] - 1];
    return [lastChar isEqualToString: @"s"]; // plural means an array...
}

- (BOOL) elementIsObject: (NSString *)elementName
{
    NSUInteger loc = [elementName rangeOfString: @"-"].location;
    return ( loc != NSNotFound || loc == 0); // if a - is in the name it is an id.. or it's a special object if it is at 0
}

- (BOOL) canHandleMappedObject: (NSDictionary *)dict
{
    NSString *elementName = [dict objectForKey: @"elementName"];
    NSString *handler = [self.selectorMap objectForKey: elementName];
    return handler != nil;
}

- (BOOL) canHandleMappedStruct: (NSDictionary *)dict
{
    NSString *elementName = [dict objectForKey: @"elementName"];
    NSString *handler = [self.selectorMap objectForKey: elementName];
    return handler != nil;
}

- (BOOL) dictContainsArray: (id)dict
{
    if ([dict isKindOfClass: [NSDictionary class]] == NO)
        return NO;

    return [[dict objectForKey: @"elementName"] isEqualToString: @"array"];
}

- (BOOL) dictContainsObject: (id)dict
{
    NSString *elementName = [dict objectForKey: @"elementName"];
    
    if ([dict isKindOfClass: [NSDictionary class]] == NO)
        return NO;
    
    if ([self.structKeys containsObject: elementName])
        return NO;
    
    return (elementName != nil && [elementName isEqualToString: @"array"] == NO);
}

- (NSString *) variableForElement: (NSString *)name withIdentifier: (NSString *)identifier
{
    NSString *var = [NSString stringWithFormat: @"%@%ld", name, _count++];
    NSString *v = [self.varToid objectForKey: var];
    
    // Check for a collision and recompute if there is one...
    if (v != nil)
    {
        var = [NSString stringWithFormat: @"%@%ld", name, _count++];
    }
    
    // Add to maps...
    [self.varToid setObject: identifier forKey: var];
    [self.idToVar setObject: var forKey: identifier];
    
    return var;
}

- (NSString *) entityNameForElementName: (NSString *)elementName
{
    return elementName;
}

- (NSString *) variableDeclarationForDictionary: (NSDictionary *)dict withIdentifier: (NSString *)identifier
{
    NSString *elementName = [dict objectForKey: @"elementName"];
    NSString *entityName = [self entityNameForElementName: elementName];
    NSString *ident = [dict objectForKey: @"id"];
    
    if (ident == nil)
    {
        ident = [dict objectForKey: @"key"];
        if (ident == nil)
        {
            ident = @"";
        }
    }
    
    NSString *varName = [self variableForElement: elementName withIdentifier: ident];
    NSString *decl = [NSString stringWithFormat: @"\t%@ %@\n",entityName, varName];

    return decl;
}

- (void) generateCodeForProperty: (NSString *)property withKey: (NSString *)key // withValue: (NSString *)value forObject: (NSDictionary *)dictionary
{
    NSLog(@"Property %@, key = %@", property, key);
}

- (void) handleArray: (NSDictionary *)dictionary forKey: (NSString *)key
{
    NSMutableArray *keys = [NSMutableArray arrayWithArray: [dictionary objectForKey: @"_ordered"]]; // get the ordered keys...
    
    if (keys == nil)
    {
        keys = [NSMutableArray arrayWithArray: [dictionary allKeys]]; // if no _orderedKeys, then use the keys.
    }
    else
    {
        NSMutableArray *theKeys = [NSMutableArray arrayWithArray: [dictionary allKeys]];
        [theKeys removeObjectsInArray: keys];
        [keys addObjectsFromArray: theKeys]; // add the key objects after the ordered objects, so we get everything.
    }

    NSEnumerator *en = [keys objectEnumerator];
    id k = nil;
    
    while ((k = [en nextObject]) != nil)
    {
        id o = [dictionary objectForKey: k];
        
        [self generateCodeForObject: o forKey: k];
    }
}

- (void) handleObject: (NSDictionary *)dict forKey: (NSString *)key
{
    if ([self canHandleMappedObject: dict])
    {
        [self handleMappedObject: dict forKey: key];
    }
    else
    {
        // NSString *elementName = [dict objectForKey: @"elementName"];
        // NSString *entityName = [self entityNameForElementName: elementName];
        NSEnumerator *en = [dict keyEnumerator];
        id k = nil;
        
        // NSLog(@"Element Name = %@", entityName);
        // NSLog(@"Object = %@", dict);
        
        while ((k = [en nextObject]) != nil)
        {
            id o = [dict objectForKey: k];
            [self generateCodeForObject: o forKey: k];
        }
    }
}

- (void) handleStruct: (NSDictionary *)dict forKey: (NSString *)key
{
    if ([self canHandleMappedStruct: dict])
    {
        [self handleMappedStruct: dict forKey: key];
    }
    else
    {
        NSEnumerator *en = [dict keyEnumerator];
        id k = nil;

        while ((k = [en nextObject]) != nil)
        {
            id o = [dict objectForKey: k];
            [self generateCodeForObject: o forKey: k];
        }
    }
}

- (void) handleProperty: (NSString *)prop forKey: (NSString *)key
{
    if ([self.skippedKeys containsObject: key])
        return;

    [self generateCodeForProperty: prop withKey: key];
    NSLog(@"Property: %@ = %@", key, prop);
}

- (void) handleMappedObject: (NSDictionary *)dict forKey: (NSString *)key
{
    NSString *selectorString = [self.selectorMap objectForKey: key];
    SEL sel = NSSelectorFromString(selectorString);
    NSArray *array = [NSArray arrayWithObjects: dict, key, nil];
    
    if ([self respondsToSelector: sel])
    {
        [self performSelector: sel withObject: array]; // perform the method to handle the given type.
    }
    else
    {
        NSLog(@"The generator does not respond to %@", selectorString);
    }
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignore "-W"
- (void) handleMappedStruct: (NSDictionary *)dict forKey: (NSString *)key
{
    NSString *selectorString = [self.selectorMap objectForKey: key];
    
    if (selectorString != nil)
    {
        SEL sel = NSSelectorFromString(selectorString);
        NSArray *array = [NSArray arrayWithObjects: dict, key, nil];
        
        if ([self respondsToSelector: sel])
        {
            [self performSelector: sel withObject: array]; // perform the method to handle the given type.
        }
        else
        {
            NSLog(@"The generator does not respond to %@", selectorString);
        }
    }
    else
    {
        NSLog(@"No selector specified for %@",key);
    }
}


- (void) generateCodeForObject: (id)object forKey: (NSString *)key
{
    if ([self.skippedKeys containsObject: key])
        return;
    
    if ([object isKindOfClass: [NSDictionary class]] == NO)
    {
        [self handleProperty: object forKey: key];
    }
    else
    {
        NSArray *keys = [object allKeys];
        
        // Iterate over the entire set of keys...
        NSEnumerator *en = [keys objectEnumerator];
        NSString *k = nil;
        
        while ((k = [en nextObject]) != nil)
        {
            if ([self.skippedKeys containsObject: k])
            {
                continue;
            }
            
            id obj = [object objectForKey: k];
            
            if ([obj isKindOfClass: [NSString class]])
            {
                [self handleProperty: obj forKey: k];
            }
            else
            {
                if ([self dictContainsArray: obj])
                {
                    [self handleArray: obj forKey: k];
                }
                else if ([self dictContainsObject: obj])
                {
                    [self handleObject: obj forKey: k];
                }
                else
                {
                    [self handleStruct: obj forKey: k];
                }
            }
        }
    }
}

- (void) generateCode
{
    // NSLog(@"XIB = %@", [self.objectDictionary allKeys]);
    // NSLog(@"TOP = %@", [[self.objectDictionary objectForKey: @"objects"] allKeys]);
    [self generateCodeForObject: [self.objectDictionary objectForKey: @"objects"]
                         forKey: nil];
}

- (void) startMethod
{
    NSLog(@"This is the abstract implementation");
}

- (void) endMethod
{
    NSLog(@"This is the abstract implementation");
}

- (void) generationComplete
{
    NSLog(@"This is the abstract implementation");
}

- (NSString *) createCategory
{
    NSString *fileName = [NSString stringWithFormat: @"%@+gui", self.name];
    
    [self startMethod];
    [self generateCode];
    [self endMethod];
        
    return fileName;
}

- (void) generate
{
    [self createCategory];
    [self generationComplete];
}

@end
