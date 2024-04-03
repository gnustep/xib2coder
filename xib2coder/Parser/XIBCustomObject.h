//
//  XIBCustomObject.h
//  XIBtoCode
//
//  Created by Gregory John Casamento on 11/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XIBCustomObject : NSObject <NSCopying>

@property (nonatomic, retain) NSString *userLabel;
@property (nonatomic, retain) NSString *customClass;

@end

NS_ASSUME_NONNULL_END
