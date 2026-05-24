//
//  XIBClassGenerator.m
//  xib2coder
//
//  Created by Gregory John Casamento on 4/12/24.
//

#import "XIBClassGenerator.h"

@implementation XIBClassGenerator

- (instancetype) initWithDictionary: (NSDictionary *)dict fileName:(NSString *)fileName
{
    self = [super init];
    if (self != nil)
    {
        self.dictionary = dict;
        self.fileName = fileName;
    }
    return self;
}

- (BOOL) generate
{
    return NO;
}

@end
