//
//  XIBAbstractParserDelegate.h
//  XIBtoCode
//
//  Created by Gregory John Casamento on 11/9/23.
//

#import <Foundation/NSObject.h>
// #import "XIBCodeGenerator.h"

@class NSString, NSDictionary, NSMutableDictionary, NSArray;

NS_ASSUME_NONNULL_BEGIN

@interface XIBAbstractCodeGenerator : NSObject
{
    NSUInteger _count;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *runtime;
@property (nonatomic, retain) NSString *ownerName;
@property (nonatomic, retain) NSString *source;

// Main object dictionary
@property (nonatomic, retain) NSDictionary *objectDictionary;

// Maps
@property (nonatomic, retain) NSArray *skippedKeys;
@property (nonatomic, retain) NSArray *structKeys;
@property (nonatomic, retain) NSMutableDictionary *idToVar;
@property (nonatomic, retain) NSMutableDictionary *varToid;
@property (nonatomic, retain) NSDictionary *classMapping;
@property (nonatomic, retain) NSDictionary *selectorMap;

// Init...
- (instancetype) initWithDictionary: (NSDictionary *)dictionary name: (NSString *)name;

// Build maps...
- (NSDictionary *) buildClassMap;

- (NSArray *) buildSkippedKeys;

- (NSArray *) buildStructKeys;

- (NSDictionary *) buildSelectorMap;

// Handle elements...
- (BOOL) elementIsAnArray: (NSString *)elementName;

- (BOOL) elementIsObject: (NSString *)elementName;

- (BOOL) canHandleMappedObject: (NSDictionary *)dict;

- (BOOL) canHandleMappedStruct: (NSDictionary *)dict;

- (BOOL) dictContainsArray: (id)dict;

- (BOOL) dictContainsObject: (id)dict;

// Build code...
- (NSString *) variableForElement: (NSString *)name withIdentifier: (NSString *)identifier;

- (NSString *) entityNameForElementName: (NSString *)elementName;

- (NSString *) variableDeclarationForDictionary: (NSDictionary *)dict withIdentifier: (NSString *)identifier;

// Handle types
- (void) handleArray: (NSDictionary *)dictionary forKey: (NSString *)key;

- (void) handleObject: (NSDictionary *)dict forKey: (NSString *)key;

- (void) handleStruct: (NSDictionary *)dict forKey: (NSString *)key;

- (void) handleProperty: (NSString *)prop forKey: (NSString *)key;

- (void) handleMappedObject: (NSDictionary *)dict forKey: (NSString *)key;

- (void) handleMappedStruct: (NSDictionary *)dict forKey: (NSString *)key;

// Generate...
- (void) generateCodeForObject: (id)object forKey: (NSString * _Nullable)key;

- (void) generateCode;

- (void) startMethod;

- (void) endMethod;

- (void) generationComplete;

- (NSString *) createCategory;

- (void) generate;

@end

NS_ASSUME_NONNULL_END

