//
//  XIBParser.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/3/24.
//

#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

#import "XIBParser.h"

@implementation XIBParser

- (instancetype) initWithData: (NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        self.parser = [[NSXMLParser alloc] initWithData: data];
        [self.parser setDelegate: self];
        
        self.stack = [NSMutableArray array];
        self.objectDictionary = [NSMutableDictionary dictionary];
        
        self.kindex = 0;
    }
    return self;
}

- (instancetype) initWithString:(NSString *)document
{
    return [self initWithData: [document dataUsingEncoding: NSUTF8StringEncoding]];
}

// Parser
- (NSDictionary *) parse
{
    [self.parser parse];
    return self.objectDictionary;
}

- (void) parserDidStartDocument: (NSXMLParser *)parser
{
    [self.stack addObject: self.objectDictionary];
}

- (void) parserDidEndDocument: (NSXMLParser *)parser
{
}

- (BOOL) elementIsObject: (NSString *)lelementName withAttributes: (NSDictionary *)dict
{
    return ([dict objectForKey: @"id"] != nil); // if it has an id attr it is an object...
}

- (BOOL) elementIsAnArray: (NSString *)elementName
{
    NSString *lastChar = [elementName substringFromIndex:[elementName length] - 1];
    return [lastChar isEqualToString: @"s"]; // plural means an array...
}

- (BOOL) elementIsKeyed: (NSString *)elementName withAttributes: (NSDictionary *)dict
{
    return ([dict objectForKey: @"key"] != nil); // if it has an id attr it is an object...

}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary *currentDictionary = [self.stack lastObject];
    NSMutableDictionary *dict = nil;

    if ([elementName isEqualToString: @"document"])
    {
        self.targetRuntime = [attributeDict objectForKey: @"targetRuntime"];
        return;
    }
    else
    {
        // NSString *className = [self.delegate classNameForElementName: elementName];
        NSString *identifier = [attributeDict objectForKey: @"id"];
        
        // Process the object...
        if ([self elementIsObject: elementName withAttributes: attributeDict])
        {
            NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary: attributeDict];
            
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         elementName, @"elementName", /* attributeDict, @"attributes", */
                                         nil];
            [attrs removeObjectForKey: @"id"];
            [dict addEntriesFromDictionary: attrs];
            
            // Add _orderedKeys...
            if (currentDictionary != nil &&
                [[currentDictionary objectForKey: @"elementName"] isEqualToString: @"array"])
            {
                NSMutableArray *orderedKeys = [currentDictionary objectForKey: @"_ordered"];
                if (orderedKeys == nil)
                {
                    orderedKeys = [NSMutableArray arrayWithObject: identifier];
                    [currentDictionary setObject: orderedKeys forKey: @"_ordered"];
                }
                else
                {
                    [orderedKeys addObject: identifier]; // insertObject: identifier atIndex: 0];
                }
            }
                
            [currentDictionary setObject: dict forKey: identifier];
        }
        else if ([self elementIsAnArray: elementName])
        {
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"array", @"elementName", nil];
            [currentDictionary setObject: dict forKey: elementName];
            self.kindex = 0;
        }
        else
        {
            NSString *key = [attributeDict objectForKey: @"key"];
            
            // If the key is nil, then use the struct name...
            if (key == nil)
            {
                key = elementName;
            }
            
            // Build dictionary...
            dict = [NSMutableDictionary dictionaryWithDictionary: attributeDict];
            [dict removeObjectForKey: @"key"];
            [dict setObject: elementName forKey: @"elementName"];
            [currentDictionary setObject: dict forKey: key];
        }
        
        // Push object onto the stack...
        [self.stack addObject: dict];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [self.stack removeLastObject]; // pop latest stack entry...
}

@end
