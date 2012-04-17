//
//  HSCryptoModel.h
//  SpyTools
//
//  Created by Chip on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCryptoFunctions : NSObject

/*Text Encryption Functions*/
int fixEncryptToPrintableUTF8(int summValue, int highPrintable, int lowPrintable);
int fixDecryptToPrintableUTF8(int summValue, int highPrintable, int lowPrintable);
NSArray *generateRandomPad(int padSize, int maxNumber);
NSString *encryptUTF8StringWithPad(NSString *inputString, NSArray *padArray);
NSString *decryptUTF8StringWithPad(NSString *inputString, NSArray *padArray);
NSString *padArrayToString(NSArray *padArray);
NSArray *keyStringToKeyArray(NSString *stringToSplit);
NSString *prepareStringForEncryption(NSString *inputString);
/*Image Encryption Functions*/


@end
