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

- (BOOL) isNumeric
{
   NSScanner *sc = [NSScanner scannerWithString: self];
   // We can pass NULL because we don't actually need the value to test
   // for if the string is numeric. This is allowable.
   if ( [sc scanFloat:NULL] )
   {
      // Ensure nothing left in scanner so that "42foo" is not accepted.
      // ("42" would be consumed by scanFloat above leaving "foo".)
      return [sc isAtEnd];
   }
   // Couldn't even scan a float :(
   return NO;
}
@end
