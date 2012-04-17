//
//  HSTextEncryptor.h
//  SpyTools
//
//  Created by Chip on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
/*Accessors*/
-(NSString *)stringToProcess;
-(int)stringLength;
/*Action Methods*/
-(NSString *)encryptStringToProcessWithKey:(NSString *)keyString;
-(NSString *)decryptStringToProcessWithKey:(NSString *)keyString;
@end
