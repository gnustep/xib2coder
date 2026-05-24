//
//  main.m
//  xib2coder
//
//  Created by Gregory John Casamento on 3/30/24.
//

#import <Foundation/Foundation.h>

#import "Parser/XIBObjCCodeBuilder.h"
#import "Parser/XIBParser.h"
#import "Generator/XIBObjCClassGenerator.h"

static void PrintUsage(const char *programName)
{
    fprintf(stderr, "usage: %s path/to/file.xib\n", programName);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 2)
        {
            PrintUsage(argv[0]);
            return 64;
        }
        
        NSString *path = [NSString stringWithUTF8String: argv[1]];
        NSData *data = [NSData dataWithContentsOfFile: path];
        if (data == nil)
        {
            fprintf(stderr, "xib2coder: unable to read '%s'\n", argv[1]);
            return 66;
        }
        
        XIBParser *xibParser = [[XIBParser alloc] initWithData: data];
        NSDictionary *result = [xibParser parse];
        NSString *runtime = xibParser.targetRuntime;
        if (result == nil || runtime == nil)
        {
            fprintf(stderr, "xib2coder: '%s' is not a valid XIB document\n", argv[1]);
            return 65;
        }
        
        XIBObjCCodeBuilder *builder = [[XIBObjCCodeBuilder alloc] initWithDictionary: result withTargetRuntime: runtime];
        id obj = [builder build];

        if (obj == nil)
        {
            return 255;
        }

        XIBObjCClassGenerator *generator = [[XIBObjCClassGenerator alloc] initWithDictionary: builder.resultsDictionary
                                                                                    fileName: [path lastPathComponent]];
        if ([generator generate] == NO)
        {
            return 255;
        }
    }
    return 0;
}
