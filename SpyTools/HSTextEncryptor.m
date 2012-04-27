//
//  HSTextEncryptor.m
//  SpyTools
//
//  Created by Chip on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSTextEncryptor.h"

@implementation HSTextEncryptor

/*Initializers*/
-(id)init{
    return [self initWithNSString:NULL];
}
-(id)initWithNSString:(NSString *)initializerString{
    self = [super init];
    if(self){
        stringToProcess = initializerString;
        stringLength = [initializerString length];
    }
    NSLog(@"HSTextEncryptor Initialized with string: %@",stringToProcess);
    return self;
}
/*Accessors*/
-(NSString *)stringToProcess{
    NSLog(@"HSTextEncryptor Accessed: %@", stringToProcess);
    return stringToProcess;
}
-(int)stringLength{
    NSLog(@"HSTextEncryptor String Length: %i", stringLength);
    return stringLength;
}
/*Action Methods*/
-(NSString *)encryptStringToProcessWithKey:(NSString *)keyString{
    NSArray *keyArray = [[NSArray alloc] initWithArray:keyStringToKeyArray(keyString)];
    NSString *encryptedString = [[NSString alloc] initWithString:encryptUTF8StringWithPad(stringToProcess, keyArray)];
    NSLog(@"HSTextEncryptor Encrypted String: %@",encryptedString);
    return encryptedString;
}
-(NSString *)decryptStringToProcessWithKey:(NSString *)keyString{
    NSArray *keyArray = [[NSArray alloc] initWithArray:keyStringToKeyArray(keyString)];
    NSString *decryptedString = [[NSString alloc] initWithString:decryptUTF8StringWithPad(stringToProcess, keyArray)];
    //NSLog(@"HSTextEncryptor Decrypted String: %@",decryptedString);
    return decryptedString;
}
-(NSString *)encryptStringToProcessWithPassphrase:(NSString *)passphraseString{
    return encryptUTF8StringWithPad(stringToProcess, NSStringToKeyArray(passphraseString));
}
-(NSString *)decryptStringToProcessWithPassphrase:(NSString *)passphraseString{
    return decryptUTF8StringWithPad(stringToProcess, NSStringToKeyArray(passphraseString));
}

-(NSString *)encryptProcessAutoSelector:(NSString *)keyString{
    NSString *testEncryptedString = [[NSString alloc] initWithString:[self encryptStringToProcessWithKey:keyString]];
    NSString *returnEncryptedString;
    if ([keyString length]==0) {
        returnEncryptedString = stringToProcess;
    }else if([testEncryptedString isEqualToString:stringToProcess]){
        returnEncryptedString = [self encryptStringToProcessWithPassphrase:keyString];
        NSLog(@"Using passphrase encryption.");
    }else {
        returnEncryptedString = [self encryptStringToProcessWithKey:keyString];
        NSLog(@"Using key encryption.");
    }
    return returnEncryptedString;
}
-(NSString *)decryptProcessAutoSelector:(NSString *)keyString{
    NSString *testDecryptedString = [[NSString alloc] initWithString:[self decryptStringToProcessWithKey:keyString]];
    NSString *returnDecryptedString;
    if ([keyString length]==0){
        returnDecryptedString = stringToProcess;
    }else if([testDecryptedString isEqualToString:stringToProcess]) {
        returnDecryptedString = [self decryptStringToProcessWithPassphrase:keyString];
        NSLog(@"Using passphrase decryption.");
    }else {
        returnDecryptedString = [self decryptStringToProcessWithKey:keyString];
        NSLog(@"Using key decryption.");
    }
    return returnDecryptedString;
}

@end
