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
        // NSData *data = [NSData dataWithContentsOfFile: @"/Users/heron/Desktop/Main.storyboard"];
        
        XIBParser *xibParser = [[XIBParser alloc] initWithData: data];
        NSDictionary *result = [xibParser parse];
        NSString *runtime = xibParser.targetRuntime;
        
        // NSDictionary *objects = [result objectForKey: @"objects"];
        XIBObjCCodeBuilder *builder = [[XIBObjCCodeBuilder alloc] initWithDictionary: result withTargetRuntime: runtime];
        id obj = [builder build];
        
        NSLog(@"resultsDictionary = %@",builder.resultsDictionary);
        
        if (obj == nil)
        {
            return 255;
        }
    }
    return 0;
}
