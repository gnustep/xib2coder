//
//  XIBCustomObject.m
//  XIBtoCode
//
//  Created by Gregory John Casamento on 11/10/23.
//

#import "XIBCustomObject.h"

@implementation XIBCustomObject

- (id) copyWithZone:(NSZone *)zone
{
    Class cls = [self class];
    XIBCustomObject *obj = [[cls allocWithZone: zone] init];

    obj.userLabel = self.userLabel;
    obj.customClass = self.customClass;

    return obj;
}

@end
