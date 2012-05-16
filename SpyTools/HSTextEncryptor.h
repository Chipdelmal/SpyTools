//
//  HSTextEncryptor.h
//  SpyTools
//
//  Created by Chip on 4/17/12.
//  Copyright (c) 2012 __Héctor Sánchez__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCryptoFunctions.h"

@interface HSTextEncryptor : NSObject{
    int         stringLength;
    NSString    *stringToProcess;
}
/*Initializers*/
-(id)init;
-(id)initWithNSString:(NSString *)initializerString;
/*Action Methods*/
-(NSString *)encryptStringToProcessWithKey:(NSString *)keyString;
-(NSString *)decryptStringToProcessWithKey:(NSString *)keyString;
-(NSString *)encryptStringToProcessWithPassphrase:(NSString *)passphraseString;
-(NSString *)decryptStringToProcessWithPassphrase:(NSString *)passphraseString;

-(NSString *)encryptProcessAutoSelector:(NSString *)keyString;
-(NSString *)decryptProcessAutoSelector:(NSString *)keyString;

@property (strong, readonly) NSString *stringToProcess;
@property (readonly) int stringLength;

@end
