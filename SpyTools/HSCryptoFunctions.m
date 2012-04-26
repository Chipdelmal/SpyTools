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
NSArray *NSStringToKeyArray(NSString *inputString){
    /*Converts a string into an array that can be used ass an encryption key*/
    char *encryptionCharArray = NSStringToCharArray(inputString);
    NSMutableArray *keyArray = [[NSMutableArray alloc] initWithCapacity:[inputString length]];
    for (int j=0; j<[inputString length]; j++) {
        [keyArray addObject:[NSNumber numberWithInt:encryptionCharArray[j]]];
    }
    return keyArray;
}
/*Image Encryption Functions*/
char *NSStringToCharArray(NSString *inputString){
    /*Converts a NSString object to a char array*/
    NSString *preparedString = [[NSString alloc] initWithString:prepareStringForEncryption(inputString)];
    int stringLength = [preparedString length];
    char *tempCString = (char *)malloc(stringLength*sizeof(char)+sizeof(char));
    strcpy(tempCString, [preparedString cStringUsingEncoding:4]);
    return tempCString;
    /*Remember to free char array after using*/
}
char *NSArrayToCharArray(NSArray *inputArray){
    int stringLength = [inputArray count];
    char *tempCString = (char *)malloc(stringLength*sizeof(char)+sizeof(char));
    for (int i=0; i<stringLength; i++) {
        tempCString[i] = [[inputArray objectAtIndex:i] intValue];
    }
    return tempCString;
}
NSMutableArray *characterToBinaryArray(int characterToConvert, int bitsNumber){
    int mask = 1;
    NSMutableArray *bitsArray = [[NSMutableArray alloc] initWithCapacity:bitsNumber];
    for (int i = 0; i<bitsNumber; i++) {
        if((characterToConvert&mask)>0){
            [bitsArray addObject:[[NSNumber alloc] initWithInt:1]];
        }else {
            [bitsArray addObject:[[NSNumber alloc] initWithInt:0]];
        }
        mask = 2*mask;
    }
    return bitsArray;
}
int binaryArrayToCharacter(NSArray *bitsArray, int bitsNumber){
    int characterValue = 0;
    int mask = 1;
    for (int i = 0; i<bitsNumber; i++) {
        characterValue = mask*[[bitsArray objectAtIndex:i] intValue] + characterValue;
        mask=2*mask;
    }
    return characterValue;
}
NSArray *setBitWithArrayValue(NSArray *inputArray, NSArray *modifierArray, int bitInput, int bitReplaced){
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[inputArray count]; i++) {
        if (i==bitReplaced) {
            [returnArray addObject:[modifierArray objectAtIndex:bitInput]];
        }else {
            [returnArray addObject:[inputArray objectAtIndex:i]];
        }
    }
    return returnArray;
}
int checkIndex(int maxValue, int indexValue){
    if (indexValue>=maxValue-1){
        return 0;
    }else{
        return indexValue+1;
    }
}
NSString *bitArrayDescriptor(NSArray *inputArray){
    NSMutableString *outputString = [[NSMutableString alloc] initWithString:@"["];
    int arraySize = [inputArray count]-1;
    for(int i=0; i<=arraySize; i++){
        [outputString appendFormat:@"%i", [[inputArray objectAtIndex:(arraySize-i)] intValue]];
    }
    [outputString appendFormat:@"]"];
    return outputString;
}
/*unsigned char NSArrayToUnsignedCharArray(NSArray *inputArray){
    int length = [inputArray count];
    unsigned char outputBuffer[length];
    for (int i=0; i<length; i++) {
        outputBuffer[i]=[[inputArray objectAtIndex:i] intValue];
        //NSLog(@"IO: [%i,%@,%i]@%i",inputBuffer[i],[decryptedImageArray objectAtIndex:i],outputBuffer[i],i);
    }
    return *outputBuffer;
}*/

NSArray *NSBitmapImageRepToNSArray(NSBitmapImageRep *inputImage, int numberOfComponents){
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    int imageWidth = CGImageGetWidth([inputImage CGImage]);
    int imageHeight = CGImageGetHeight([inputImage CGImage]);
    
    unsigned long tempPixelValues[numberOfComponents];
    
    [imageArray addObject:[NSNumber numberWithInt:imageWidth]];
    [imageArray addObject:[NSNumber numberWithInt:imageHeight]];
    
    for (int j=0; j<imageHeight; j++) {
        for (int i=0; i<imageWidth; i++) {
            [inputImage getPixel:tempPixelValues atX:i y:j];
            for (int k=0; k<numberOfComponents; k++) {
                //NSLog(@"[%i,%i]::[%i]",j,i,k);
                [imageArray addObject:[NSNumber numberWithInt:tempPixelValues[k]]];
            }
        }
    }
    return imageArray;    
}
NSBitmapImageRep *NSArrayToNSBitmapImageRep(NSArray *inputArray, int numberOfComponents){
    NSBitmapImageRep *image = [[NSBitmapImageRep alloc] init];
    
    int imageWidth = [[inputArray objectAtIndex:0] intValue];
    int imageHeight = [[inputArray objectAtIndex:1] intValue];
    
    unsigned long tempPixelValues[numberOfComponents];
    
    int arrayIndex = 2;
    
    for (int j=0; j<imageHeight; j++) {
        for (int i=0; i<imageWidth; i++) {
            for (int k=0; k<numberOfComponents; k++) {
                tempPixelValues[k] = [[inputArray objectAtIndex:arrayIndex] intValue];
                arrayIndex++;
            }
            [image setPixel:tempPixelValues atX:i y:j];
        }
    }
    
    return image;
}



@end
