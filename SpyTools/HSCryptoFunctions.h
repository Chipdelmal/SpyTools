//
//  HSCryptoModel.h
//  SpyTools
//
//  Created by Chip on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSImageEncryptor.h"

@interface HSCryptoFunctions : NSObject

/*Text Encryption Functions*/
/*One Time Pad*/
int fixEncryptToPrintableUTF8(int summValue, int highPrintable, int lowPrintable);
int fixDecryptToPrintableUTF8(int summValue, int highPrintable, int lowPrintable);
NSArray *generateRandomPad(int padSize, int maxNumber);
NSString *generateRandomKey(int padLength, int maxNumber);
NSString *encryptUTF8StringWithPad(NSString *inputString, NSArray *padArray);
NSString *decryptUTF8StringWithPad(NSString *inputString, NSArray *padArray);
NSString *padArrayToString(NSArray *padArray);
NSArray *keyStringToKeyArray(NSString *stringToSplit);
NSString *prepareStringForEncryption(NSString *inputString);
NSArray *NSStringToKeyArray(NSString *inputString);
/*Substitution Cypher*/
NSArray *generateAllowedCharactersArray(int minUTF, int maxUTF);
NSArray *generateRequiredCharactersArray(NSString *stringToProcess);
NSArray *generateRandomSubstitutionKey(NSArray *requiredCharactersArray, NSArray *allowedCharactersArray);
NSString *encryptSubstitution(NSString *stringToBeEncrypted, NSArray *requiredCharactersArray, NSArray *keyArray);
NSString *decryptSubstitution(NSString *stringToBeDecrypted, NSArray *requiredCharactersArray, NSArray *keyArray);

/*Image Encryption Functions*/
char *NSStringToCharArray(NSString *inputString);
char *NSArrayToCharArray(NSArray *inputArray);
NSMutableArray *characterToBinaryArray(int characterToConvert, int bitsNumber);
int binaryArrayToCharacter(NSArray *bitsArray, int bitsNumber);
NSArray *setBitWithArrayValue(NSArray *inputArray, NSArray *modifierArray, int bitInput, int bitReplaced);
int checkIndex(int maxValue, int indexValue);
NSString *bitArrayDescriptor(NSArray *inputArray);
int imageToEncryptInSizeInBits(NSBitmapImageRep *imageToAnalyze);
int imageToBeEncryptedRequiredSize(NSBitmapImageRep *imageToAnalyze, int numberOfBits);
int stringToBeEncryptedRequiredSize(NSString *stringToAnalyze);

/*Prototypes*/
//unsigned char NSArrayToUnsignedCharArray(NSArray *inputArray);
NSArray *NSBitmapImageRepToNSArray(NSBitmapImageRep *inputImage, int numberOfComponents);
NSBitmapImageRep *NSArrayToNSBitmapImageRep(NSArray *inputArray, int numberOfComponents);

@end
