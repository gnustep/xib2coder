//
//  NSString+Additions.m
//  XIBtoCode
//
//  Created by Gregory John Casamento on 11/11/23.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *) stringByCapitalizingFirstCharacter
{
  unichar c = [self characterAtIndex: 0];
  NSRange range = NSMakeRange(0,1);
  NSString *oneChar = [[NSString stringWithFormat:@"%C",c] uppercaseString];
  NSString *name = [self stringByReplacingCharactersInRange: range withString: oneChar];
  
  return name;
}

@end
