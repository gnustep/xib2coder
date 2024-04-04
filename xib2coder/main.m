//
//  main.m
//  xib2coder
//
//  Created by Gregory John Casamento on 3/30/24.
//

#import <Foundation/Foundation.h>

#import "Parser/XIBObjCCodeBuilder.h"
#import "Parser/XIBParser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSData *data = [NSData dataWithContentsOfFile: @"/Users/heron/Desktop/MainMenu.xib"];
        XIBParser *xibParser = [[XIBParser alloc] initWithData: data];
        NSDictionary *result = [xibParser parse];
        NSDictionary *objects = [result objectForKey: @"objects"];
        XIBObjCCodeBuilder *builder = [[XIBObjCCodeBuilder alloc] initWithDictionary: objects];
        BOOL success = [builder build];
        
        if (success == NO)
        {
            return 255;
        }
    }
    return 0;
}
