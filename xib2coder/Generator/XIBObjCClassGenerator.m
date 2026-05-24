//
//  XIBObjCClassGenerator.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/12/24.
//

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSCharacterSet.h>
#import <stdio.h>

#import "XIBObjCClassGenerator.h"
#import "../Parser/XIBObjCClassBuilder.h"


@implementation XIBObjCClassGenerator

- (BOOL) typeNeedsPointer: (NSString *)type
{
    NSSet *scalarTypes = [NSSet setWithObjects:
                          @"BOOL",
                          @"CGFloat",
                          @"NSInteger",
                          @"NSUInteger",
                          @"int",
                          @"float",
                          @"double",
                          nil];
    return [scalarTypes containsObject: type] == NO;
}

- (NSString *) safeIdentifierForName: (NSString *)name
{
    NSCharacterSet *identifierCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                            @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];
    NSMutableString *result = [NSMutableString string];
    NSUInteger i = 0;

    for (i = 0; i < [name length]; i++)
    {
        unichar c = [name characterAtIndex: i];
        if ([identifierCharacters characterIsMember: c])
        {
            [result appendFormat: @"%C", c];
        }
        else
        {
            [result appendString: @"_"];
        }
    }

    if ([result length] == 0)
    {
        return @"value";
    }

    unichar first = [result characterAtIndex: 0];
    if (first >= '0' && first <= '9')
    {
        [result insertString: @"value_" atIndex: 0];
    }

    NSSet *reservedWords = [NSSet setWithObjects:
                            @"auto", @"break", @"case", @"char", @"class", @"const",
                            @"continue", @"default", @"do", @"double", @"else",
                            @"enum", @"extern", @"float", @"for", @"goto", @"if",
                            @"inline", @"int", @"long", @"register", @"restrict",
                            @"return", @"short", @"signed", @"sizeof", @"static",
                            @"struct", @"switch", @"typedef", @"union", @"unsigned",
                            @"void", @"volatile", @"while", @"id", @"self", @"super",
                            nil];
    if ([reservedWords containsObject: result])
    {
        [result appendString: @"Value"];
    }

    return result;
}

- (NSString *) declarationForAttribute: (NSString *)name type: (NSString *)type
{
    NSString *identifier = [self safeIdentifierForName: name];

    if ([self typeNeedsPointer: type])
    {
        return [NSString stringWithFormat: @"@property (nonatomic, retain) %@ *%@;\n", type, identifier];
    }

    return [NSString stringWithFormat: @"@property (nonatomic, assign) %@ %@;\n", type, identifier];
}

- (BOOL) shouldDeclareClass: (XIBObjCClassBuilder *)builder
{
    return builder.name != nil && NSClassFromString(builder.name) == Nil;
}

- (NSString *) objcStringLiteralForString: (NSString *)string
{
    NSMutableString *result = [NSMutableString stringWithString: string];

    [result replaceOccurrencesOfString: @"\\" withString: @"\\\\" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"\"" withString: @"\\\"" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"\n" withString: @"\\n" options: 0 range: NSMakeRange(0, [result length])];

    return [NSString stringWithFormat: @"@\"%@\"", result];
}

- (void) appendClassInfoDictionaryForBuilder: (XIBObjCClassBuilder *)builder toString: (NSMutableString *)output indent: (NSString *)indent
{
    NSArray *attributeNames = [[builder.attributes allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSUInteger j = 0;

    if ([attributeNames count] == 0)
    {
        [output appendString: @"[NSDictionary dictionary]"];
        return;
    }

    [output appendString: @"[NSDictionary dictionaryWithObjectsAndKeys:\n"];
    for (j = 0; j < [attributeNames count]; j++)
    {
        NSString *attributeName = [attributeNames objectAtIndex: j];
        NSString *attributeType = [builder.attributes objectForKey: attributeName];

        [output appendFormat: @"%@    %@, %@,\n",
         indent,
         [self objcStringLiteralForString: attributeType],
         [self objcStringLiteralForString: [self safeIdentifierForName: attributeName]]];
    }
    [output appendFormat: @"%@    nil]", indent];
}

- (NSString *) generatedCode
{
    NSMutableString *output = [NSMutableString string];
    NSArray *classNames = [[self.dictionary allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSUInteger i = 0;

    [output appendString: @"#import <Foundation/Foundation.h>\n"];
    [output appendString: @"\n"];

    for (i = 0; i < [classNames count]; i++)
    {
        NSString *className = [classNames objectAtIndex: i];
        XIBObjCClassBuilder *builder = [self.dictionary objectForKey: className];
        NSArray *attributeNames = [[builder.attributes allKeys] sortedArrayUsingSelector: @selector(compare:)];
        NSUInteger j = 0;

        if ([self shouldDeclareClass: builder] == NO)
        {
            continue;
        }

        for (j = 0; j < [attributeNames count]; j++)
        {
            NSString *attributeType = [builder.attributes objectForKey: [attributeNames objectAtIndex: j]];
            if ([self typeNeedsPointer: attributeType] && [attributeType isEqualToString: @"NSString"] == NO)
            {
                [output appendFormat: @"@class %@;\n", attributeType];
            }
        }
    }

    if ([output hasSuffix: @"\n\n"] == NO)
    {
        [output appendString: @"\n"];
    }

    for (i = 0; i < [classNames count]; i++)
    {
        NSString *className = [classNames objectAtIndex: i];
        XIBObjCClassBuilder *builder = [self.dictionary objectForKey: className];
        NSArray *attributeNames = [[builder.attributes allKeys] sortedArrayUsingSelector: @selector(compare:)];
        NSUInteger j = 0;

        if ([self shouldDeclareClass: builder] == NO)
        {
            continue;
        }

        [output appendFormat: @"@interface %@ : NSObject\n", builder.name];

        for (j = 0; j < [attributeNames count]; j++)
        {
            NSString *attributeName = [attributeNames objectAtIndex: j];
            NSString *attributeType = [builder.attributes objectForKey: attributeName];
            [output appendString: [self declarationForAttribute: attributeName type: attributeType]];
        }

        [output appendString: @"@end\n\n"];
    }

    for (i = 0; i < [classNames count]; i++)
    {
        NSString *className = [classNames objectAtIndex: i];
        XIBObjCClassBuilder *builder = [self.dictionary objectForKey: className];

        if ([self shouldDeclareClass: builder] == NO)
        {
            continue;
        }

        [output appendFormat: @"@implementation %@\n@end\n\n", builder.name];
    }

    [output appendString: @"NSDictionary *XIBGeneratedClassInfo(void)\n{\n"];
    if ([classNames count] == 0)
    {
        [output appendString: @"    return [NSDictionary dictionary];\n"];
    }
    else
    {
        [output appendString: @"    return [NSDictionary dictionaryWithObjectsAndKeys:\n"];
        for (i = 0; i < [classNames count]; i++)
        {
            NSString *className = [classNames objectAtIndex: i];
            XIBObjCClassBuilder *builder = [self.dictionary objectForKey: className];

            [output appendString: @"        "];
            [self appendClassInfoDictionaryForBuilder: builder toString: output indent: @"        "];
            [output appendFormat: @", %@,\n", [self objcStringLiteralForString: builder.name]];
        }
        [output appendString: @"        nil];\n"];
    }
    [output appendString: @"}\n"];

    self.header = output;
    self.source = @"";
    return output;
}

- (BOOL) generate
{
    NSString *code = [self generatedCode];
    printf("%s", [code UTF8String]);
    return YES;
}

@end
