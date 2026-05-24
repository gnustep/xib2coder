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
#import <Foundation/NSFileManager.h>
#import <Foundation/NSError.h>
#import <stdio.h>

#import "XIBObjCClassGenerator.h"
#import "../Parser/XIBObjCClassBuilder.h"


@implementation XIBObjCClassGenerator

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

- (NSString *) categoryName
{
    return @"XIB2CoderNSCoding";
}

- (BOOL) shouldGenerateCodingCategoryForBuilder: (XIBObjCClassBuilder *)builder
{
    NSString *customClass = [builder.dictionary objectForKey: @"customClass"];
    return builder.name != nil && customClass != nil && [customClass length] > 0;
}

- (NSString *) objcStringLiteralForString: (NSString *)string
{
    NSMutableString *result = [NSMutableString stringWithString: string];

    [result replaceOccurrencesOfString: @"\\" withString: @"\\\\" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"\"" withString: @"\\\"" options: 0 range: NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString: @"\n" withString: @"\\n" options: 0 range: NSMakeRange(0, [result length])];

    return [NSString stringWithFormat: @"@\"%@\"", result];
}

- (NSString *) encodeStatementForAttribute: (NSString *)name type: (NSString *)type
{
    NSString *identifier = [self safeIdentifierForName: name];
    NSString *key = [self objcStringLiteralForString: identifier];

    if ([type isEqualToString: @"BOOL"])
    {
        return [NSString stringWithFormat: @"    [coder encodeBool: self.%@ forKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"NSInteger"])
    {
        return [NSString stringWithFormat: @"    [coder encodeInteger: self.%@ forKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"NSUInteger"])
    {
        return [NSString stringWithFormat: @"    [coder encodeInteger: (NSInteger)self.%@ forKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"int"])
    {
        return [NSString stringWithFormat: @"    [coder encodeInt: self.%@ forKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"float"])
    {
        return [NSString stringWithFormat: @"    [coder encodeFloat: self.%@ forKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"double"])
    {
        return [NSString stringWithFormat: @"    [coder encodeDouble: self.%@ forKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"CGFloat"])
    {
        return [NSString stringWithFormat: @"    [coder encodeDouble: (double)self.%@ forKey: %@];\n", identifier, key];
    }

    return [NSString stringWithFormat: @"    [coder encodeObject: self.%@ forKey: %@];\n", identifier, key];
}

- (NSString *) decodeStatementForAttribute: (NSString *)name type: (NSString *)type
{
    NSString *identifier = [self safeIdentifierForName: name];
    NSString *key = [self objcStringLiteralForString: identifier];

    if ([type isEqualToString: @"BOOL"])
    {
        return [NSString stringWithFormat: @"        self.%@ = [coder decodeBoolForKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"NSInteger"])
    {
        return [NSString stringWithFormat: @"        self.%@ = [coder decodeIntegerForKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"NSUInteger"])
    {
        return [NSString stringWithFormat: @"        self.%@ = (NSUInteger)[coder decodeIntegerForKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"int"])
    {
        return [NSString stringWithFormat: @"        self.%@ = [coder decodeIntForKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"float"])
    {
        return [NSString stringWithFormat: @"        self.%@ = [coder decodeFloatForKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"double"])
    {
        return [NSString stringWithFormat: @"        self.%@ = [coder decodeDoubleForKey: %@];\n", identifier, key];
    }
    else if ([type isEqualToString: @"CGFloat"])
    {
        return [NSString stringWithFormat: @"        self.%@ = (CGFloat)[coder decodeDoubleForKey: %@];\n", identifier, key];
    }

    return [NSString stringWithFormat: @"        self.%@ = [coder decodeObjectForKey: %@];\n", identifier, key];
}

- (void) appendCodingCategoryForBuilder: (XIBObjCClassBuilder *)builder toString: (NSMutableString *)output
{
    NSArray *attributeNames = [[builder.attributes allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSUInteger j = 0;

    [output appendFormat: @"@interface %@ (%@) <NSCoding>\n@end\n\n",
     builder.name,
     [self categoryName]];

    [output appendFormat: @"@implementation %@ (%@)\n\n",
     builder.name,
     [self categoryName]];

    [output appendString: @"- (void) encodeWithCoder: (NSCoder *)coder\n{\n"];
    for (j = 0; j < [attributeNames count]; j++)
    {
        NSString *attributeName = [attributeNames objectAtIndex: j];
        NSString *attributeType = [builder.attributes objectForKey: attributeName];
        [output appendString: [self encodeStatementForAttribute: attributeName type: attributeType]];
    }
    [output appendString: @"}\n\n"];

    [output appendString: @"- (instancetype) initWithCoder: (NSCoder *)coder\n{\n"];
    [output appendString: @"    self = [self init];\n"];
    [output appendString: @"    if (self != nil)\n"];
    [output appendString: @"    {\n"];
    for (j = 0; j < [attributeNames count]; j++)
    {
        NSString *attributeName = [attributeNames objectAtIndex: j];
        NSString *attributeType = [builder.attributes objectForKey: attributeName];
        [output appendString: [self decodeStatementForAttribute: attributeName type: attributeType]];
    }
    [output appendString: @"    }\n"];
    [output appendString: @"    return self;\n"];
    [output appendString: @"}\n\n"];

    [output appendString: @"@end\n\n"];
}

- (NSString *) generatedCodeForBuilder: (XIBObjCClassBuilder *)builder
{
    NSMutableString *output = [NSMutableString string];

    [output appendString: @"#import <Foundation/Foundation.h>\n"];
    [output appendFormat: @"#import \"%@.h\"\n\n", builder.name];

    [self appendCodingCategoryForBuilder: builder toString: output];

    return output;
}

- (NSString *) outputDirectory
{
    NSString *directory = [self.fileName stringByDeletingLastPathComponent];

    if (directory == nil || [directory length] == 0 || [directory isEqualToString: self.fileName])
    {
        return [[NSFileManager defaultManager] currentDirectoryPath];
    }

    return directory;
}

- (NSString *) outputPathForBuilder: (XIBObjCClassBuilder *)builder
{
    NSString *fileName = [NSString stringWithFormat: @"%@+%@.m", builder.name, [self categoryName]];
    return [[self outputDirectory] stringByAppendingPathComponent: fileName];
}

- (NSString *) generatedCode
{
    NSMutableString *output = [NSMutableString string];
    NSArray *classNames = [[self.dictionary allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSUInteger i = 0;

    for (i = 0; i < [classNames count]; i++)
    {
        NSString *className = [classNames objectAtIndex: i];
        XIBObjCClassBuilder *builder = [self.dictionary objectForKey: className];

        if ([self shouldGenerateCodingCategoryForBuilder: builder] == NO)
        {
            continue;
        }

        [output appendString: [self generatedCodeForBuilder: builder]];
    }

    self.header = output;
    self.source = @"";
    return output;
}

- (BOOL) generate
{
    NSArray *classNames = [[self.dictionary allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSUInteger i = 0;

    for (i = 0; i < [classNames count]; i++)
    {
        NSString *className = [classNames objectAtIndex: i];
        XIBObjCClassBuilder *builder = [self.dictionary objectForKey: className];
        NSString *code = nil;
        NSString *path = nil;
        NSError *error = nil;

        if ([self shouldGenerateCodingCategoryForBuilder: builder] == NO)
        {
            continue;
        }

        code = [self generatedCodeForBuilder: builder];
        path = [self outputPathForBuilder: builder];

        if ([code writeToFile: path atomically: YES encoding: NSUTF8StringEncoding error: &error] == NO)
        {
            fprintf(stderr, "xib2coder: unable to write '%s': %s\n",
                    [path UTF8String],
                    [[error localizedDescription] UTF8String]);
            return NO;
        }
    }

    return YES;
}

@end
