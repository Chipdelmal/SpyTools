//
//  HSCryptoModel.m
//  SpyTools
//
//  Created by Chip on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSCryptoFunctions.h"

@implementation HSCryptoFunctions

/*Text Encryption Functions*/
int fixEncryptToPrintableUTF8(int summValue, int highPrintable, int lowPrintable){
    /*Corrects the value of the encrypted character if it lies beyond the printable characters set*/
    return ((summValue-lowPrintable) % (highPrintable-lowPrintable))+lowPrintable;
}
int fixDecryptToPrintableUTF8(int summValue, int highPrintable, int lowPrintable){
    /*Corrects the value of the decrypted character if it lies beyond the printable characters set*/
    int rotateTimes = abs(summValue-lowPrintable)/((highPrintable-lowPrintable));
    if (abs(summValue-lowPrintable)%(highPrintable-lowPrintable)==0) {
        summValue = lowPrintable;
    }
    if ((summValue-lowPrintable)<0) {
        summValue=(rotateTimes+1)*(highPrintable-lowPrintable)+summValue;
    }
    return summValue;
}
NSArray *generateRandomPad(int padSize, int maxNumber){
    /*Generates a random key given the size and the maximum allowed number of values each part of the key can have*/
    NSMutableArray *phaseArray = [[NSMutableArray alloc] initWithCapacity:padSize];
    for (int i=0; i<padSize; i++) {
        [phaseArray addObject:[[NSNumber alloc] initWithInt:arc4random() % maxNumber+1]];
    }
    return phaseArray;
}
NSString *encryptUTF8StringWithPad(NSString *inputString, NSArray *padArray){
    /*Encrypts a string given a key in the form of an array*/
    NSString *preparedString = [[NSString alloc] initWithString:prepareStringForEncryption(inputString)];
    int stringLength = [preparedString length];
    int tempPhase = 0;
    char *tempCString = (char *)malloc(stringLength*sizeof(char)+sizeof(char));
    strcpy(tempCString, [preparedString cStringUsingEncoding:4]);
    
    int j=0;
    for (int i=0; i<(stringLength); i++) {
        tempPhase = tempCString[i]+[[padArray objectAtIndex:j] intValue];
        tempCString[i]= fixEncryptToPrintableUTF8(tempPhase,126,32);
        if (j<[padArray count]-1) {
            j++;
        }else {
            j=0;
        }
    }
    NSString *returnString = [[NSString alloc] initWithCString:tempCString encoding:4];
    free(tempCString);
    return returnString;
}
NSString *decryptUTF8StringWithPad(NSString *inputString, NSArray *padArray){
    /*Encrypts a string given a key in the form of an array*/
    int stringLength = [inputString length];
    int tempPhase = 0;
    char *tempCString = (char *)malloc(stringLength*sizeof(char)+sizeof(char));
    strcpy(tempCString, [inputString cStringUsingEncoding:4]);
    
    int j=0;
    for (int i=0; i<(stringLength); i++) {
        tempPhase = tempCString[i]-[[padArray objectAtIndex:j] intValue];
        tempCString[i]= fixDecryptToPrintableUTF8(tempPhase,126,32);
        //Fix index for small pad (if the pad is smaller than the text the pad is repeated)
        if (j<[padArray count]-1) {
            j++;
        }else {
            j=0;
        }
    }
    NSString *returnString = [[NSString alloc] initWithCString:tempCString encoding:4];
    free(tempCString);
    return returnString;
}
NSString *padArrayToString(NSArray *padArray){
    /*Converts a key array to a string*/
    NSMutableString *arrayString = [[NSMutableString alloc] init];
    for (int i=0; i<[padArray count]; i++) {
        [arrayString appendFormat:@"%i",[[padArray objectAtIndex:i] intValue]];
        if (i<[padArray count]-1) {
            [arrayString appendString:@","];
            
        }
    }
    return arrayString;
}
NSArray *keyStringToKeyArray(NSString *stringToSplit){
    /*Converts a string to a key array*/
    NSArray *tempArray = [[NSArray alloc] initWithArray:[stringToSplit componentsSeparatedByString:@","]];
    NSMutableArray *tempIntArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[tempArray count]; i++) {
        [tempIntArray addObject:[[NSNumber alloc] initWithInt:[[tempArray objectAtIndex:i] intValue]]];
    }
    return tempIntArray;
}
NSString *prepareStringForEncryption(NSString *inputString){
    /*Prepares a string for encryption*/
    NSString *myString = inputString;
    NSData *stringData = [myString dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
    NSString *cleanString = [[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding];
    return cleanString;
}

@end
