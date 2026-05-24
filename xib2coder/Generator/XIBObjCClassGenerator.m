//
//  XIBObjCClassGenerator.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/12/24.
//

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>

#import "XIBObjCClassGenerator.h"


@implementation XIBObjCClassGenerator

- (BOOL) generate
{
    NSEnumerator *en = [self.dictionary keyEnumerator];
    NSString *k = nil;
    
    while ((k = [en nextObject]) != nil)
    {
        NSDictionary *d = [self.dictionary objectForKey: k];
    }
    
    return YES;
}

@end
