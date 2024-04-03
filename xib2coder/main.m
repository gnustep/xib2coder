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
        XIBObjCCodeBuilder *builder = [[XIBObjCCodeBuilder alloc] initWithDictionary: result];
        NSString *code = [builder build];
        NSLog(@"Code: %@", code);
    }
    return 0;
}
