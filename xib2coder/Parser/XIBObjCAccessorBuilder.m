//
//  XIBObjCAccessorBuilder.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/4/24.
//

#import "XIBObjCAccessorBuilder.h"

@implementation XIBObjCAccessorBuilder

- (instancetype) initWithKey: (id)k andObject: (id)o
{
    self = [super init];
    if (self != nil)
    {
        self.key = k;
        self.object = o;
    }
    return self;
}

- (BOOL) build
{
    return NO;
}

@end
