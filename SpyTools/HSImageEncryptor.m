//
//  HSImageEncryptor.m
//  SpyTools
//
//  Created by Chip on 4/18/12.
//  Copyright (c) 2012 __Héctor Sánchez__. All rights reserved.
//

#import "HSImageEncryptor.h"

@implementation HSImageEncryptor
@synthesize imageBitmapRep;
@synthesize imageWidth;
@synthesize imageHeight;
@synthesize bitsPerPixel;
@synthesize numberOfComponents;

/*Initializers*/
-(id)init{
    return [self initWithData:NULL];
}
-(id)initWithData:(NSData *)imageData{
    self = [super init];
    if(self){
        imageBitmapRep = [[NSBitmapImageRep alloc] initWithData:imageData];
        imageWidth = CGImageGetWidth([imageBitmapRep CGImage]);
        imageHeight = CGImageGetHeight([imageBitmapRep CGImage]);
        bitsPerPixel = [imageBitmapRep bitsPerPixel];
        numberOfComponents = [imageBitmapRep samplesPerPixel];
        NSLog(@"[%i,%i]::[bpp:%i - noc:%i]", imageWidth, imageHeight, bitsPerPixel, numberOfComponents);
    }
    return self;
}
/*Action Methods*/
-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andString:(NSString *)stringToBeEncrypted{
    /*Create characters array to encrypt in the image*/
    char *testChar = NSStringToCharArray(prepareStringForEncryption(stringToBeEncrypted));
    int sizeOfString = strlen(testChar);
    /*Encrypting characters array into image*/
    NSBitmapImageRep *imageBitmapRepOut = encryptInImage(imageBitmapRep, testChar, numberOfBits, sizeOfString);
    /*Releasing and returning data*/
    free(testChar);
    NSLog(@"Data has been succesfully encrypted!");
    return imageBitmapRepOut;
}
-(NSString *)decryptImageWithBits:(int)numberOfBits{
    /*Obtain the data hidden in the image as a bytes array*/
    NSArray *readString = [[NSArray alloc] initWithArray:decryptImageLinearly(imageBitmapRep, numberOfBits)];
    /*Convert bytes into a char array and then into an NString*/
    NSString *readNSString = [[NSString alloc] initWithCString:NSArrayToCharArray(readString) encoding:4];
    return readNSString;
}

-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andData:(NSData *)dataToBeEncrypted{
    /*Creating buffer for data*/
    int dataLength = [dataToBeEncrypted length]+dataLengthBits;
    unsigned char testCharTemp[dataLength];
    [dataToBeEncrypted getBytes:testCharTemp];
    NSLog(@"Encrypted Data Length: %i",dataLength);

    /*Data Length Header*/
    NSArray *binaryLength = characterToBinaryArray(dataLength, dataLengthBits);
    //NSLog(@"Binary Length: %@", binaryLength);
    NSArray *lengthInBytes = binaryArrayToBytesCharactersArray(binaryLength, 8);  /*The Error is Here!!!*/
    //NSLog(@"Length in Bytes: %@", lengthInBytes);
    unsigned char testChar[dataLength+dataLengthBits];
    for (int i=0; i<dataLength+[lengthInBytes count]; i++) {
        if (i<dataLengthBits/8) {
            if (i<[lengthInBytes count]) {
                testChar[i]=[[lengthInBytes objectAtIndex:i] intValue];
            }else {
                testChar[i]=0;
            }            
            //NSLog(@"%i",testChar[i]);
        }else {
            testChar[i]=testCharTemp[i-dataLengthBits];
        }
    }
    
    NSBitmapImageRep *imageBitmapRepOut = encryptInImage(imageBitmapRep, (char *)testChar, numberOfBits, dataLength);
    NSLog(@"Data has been succesfully encrypted!");
    return  imageBitmapRepOut;
}
-(NSData *)decryptImageDataWithBits:(int)numberOfBits{
    /*Obtain the data hidden in the image as a bytes array*/
    NSArray *readString = [[NSArray alloc] initWithArray:decryptImageLinearly(imageBitmapRep, numberOfBits)];
    /*Convert read array into NSData object*/
    NSData *dataOutput = [[NSData alloc] initWithData:NSArrayToData(readString)];
    return dataOutput;
}
-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andData:(NSData *)dataToBeEncrypted andKey:(NSString *)keyString{
    NSLog(@"Encrypting with key: %@",keyString);
    
    /*Creating buffer for data*/
    int dataLength = [dataToBeEncrypted length]+dataLengthBits;
    unsigned char testCharTemp[dataLength];
    [dataToBeEncrypted getBytes:testCharTemp];
    
    /*Data Length Header*/
    NSArray *binaryLength = characterToBinaryArray(dataLength, dataLengthBits);
    NSArray *lengthInBytes = binaryArrayToBytesCharactersArray(binaryLength, 8);    
    unsigned char testChar[dataLength+dataLengthBits];
    for (int i=0; i<dataLength+[lengthInBytes count]; i++) {
        if (i<dataLengthBits/8) {
            if (i<[lengthInBytes count]) {
                testChar[i]=[[lengthInBytes objectAtIndex:i] intValue];
            }else {
                testChar[i]=0;
            }            
            //NSLog(@"%i",testChar[i]);
        }else {
            testChar[i]=testCharTemp[i-dataLengthBits];
        }
    }
    
    /*Encryption*/
    NSArray *keyArray = [[NSArray alloc] initWithArray:NSStringToKeyArray(prepareStringForEncryption(keyString))];
    int j=0;
    for (int i=0; i<sizeof(testChar)/sizeof(unsigned char); i++) {
        testChar[i]=testChar[i]+[[keyArray objectAtIndex:j] intValue];
        if (j<[keyArray count]-1) {
            j++;
        }else {
            j=0;
        }
    }
    
    NSBitmapImageRep *imageBitmapRepOut = encryptInImage(imageBitmapRep, (char *)testChar, numberOfBits, dataLength);
    NSLog(@"Data has been succesfully encrypted!");
    return imageBitmapRepOut;
}
-(NSData *)decryptImageDataWithBits:(int)numberOfBits andKey:(NSString *)keyString{
    NSArray *readStringTemp = [[NSArray alloc] initWithArray:decryptImageLinearly(imageBitmapRep, numberOfBits)];
    /*Decrypt*/
    NSMutableArray *readString = [[NSMutableArray alloc] initWithArray:readStringTemp];
    NSArray *keyArray = [[NSArray alloc] initWithArray:NSStringToKeyArray(prepareStringForEncryption(keyString))];
    NSArray *phased = [[NSArray alloc] initWithArray:unphasedArray(readString,keyArray)];
    NSData *dataOutput = [[NSData alloc] initWithData:NSArrayToData(phased)];
    return dataOutput;
}


-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andFileData:(NSData *)dataToBeEncrypted andExtension:(NSString *)extensionString{
    NSLog(@"Encrypting with extension.");
    /*Creating buffer for data*/
    int dataLength = [dataToBeEncrypted length]+dataLengthBits;
    unsigned char testCharTemp[dataLength];
    [dataToBeEncrypted getBytes:testCharTemp];
    
    /*Data Length and Extension Header*/
    char *extensionArray = NSStringToCharArray(extensionString);
    //NSLog(@"Extension: %s",extensionArray);
    NSArray *binaryLength = characterToBinaryArray(dataLength, dataLengthBits);
    NSArray *lengthInBytes = binaryArrayToBytesCharactersArray(binaryLength, 8);    
    unsigned char testChar[dataLength+dataLengthBits];
    int charExtensionIndex=0;
    for (int i=0; i<dataLength+[lengthInBytes count]; i++) {
        if (i<dataLengthBits/8) {
            if (i<[lengthInBytes count]) {
                testChar[i]=[[lengthInBytes objectAtIndex:i] intValue];
            }else {
                testChar[i]=0;
            }            
            //NSLog(@"%i",testChar[i]);
        }else if(i<(extensionBits+dataLengthBits)/8){
            testChar[i]=extensionArray[charExtensionIndex];
            charExtensionIndex++;
            //NSLog(@"Extension Character written: %i",testChar[i]);
        }else{
            testChar[i]=testCharTemp[i-(dataLengthBits+extensionBits)];
        }
    }
    
    
    NSBitmapImageRep *imageBitmapRepOut = encryptInImage(imageBitmapRep, (char *)testChar, numberOfBits, dataLength);
    NSLog(@"Data has been succesfully encrypted!");
    free(extensionArray);
    return  imageBitmapRepOut; 
}
-(NSData *)decryptFileDataWithBits:(int)numberOfBits andStoreExtensionIn:(NSString **)extensionPtr{
    /*Obtain the data hidden in the image as a bytes array*/
    NSArray *readString = [[NSArray alloc] initWithArray:decryptImageLinearly(imageBitmapRep, numberOfBits)];
    /*Convert read array into NSData object*/
    NSString *readExtension = [[NSString alloc] init];
    NSData *dataOutput = [[NSData alloc] initWithData:NSArrayToDataWithExtension(readString, &readExtension)];
    *extensionPtr = readExtension;
    return dataOutput;
}
-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andFileData:(NSData *)dataToBeEncrypted andExtension:(NSString *)extensionString andKey:(NSString *)keyString{
    NSLog(@"Encrypting with extension.");
    /*Creating buffer for data*/
    int dataLength = [dataToBeEncrypted length]+dataLengthBits;
    unsigned char testCharTemp[dataLength];
    [dataToBeEncrypted getBytes:testCharTemp];
    
    /*Data Length and Extension Header*/
    char *extensionArray = NSStringToCharArray(extensionString);
    //NSLog(@"Extension: %s",extensionArray);
    NSArray *binaryLength = characterToBinaryArray(dataLength, dataLengthBits);
    NSArray *lengthInBytes = binaryArrayToBytesCharactersArray(binaryLength, 8);    
    unsigned char testChar[dataLength+dataLengthBits];
    int charExtensionIndex=0;
    for (int i=0; i<dataLength+[lengthInBytes count]; i++) {
        if (i<dataLengthBits/8) {
            if (i<[lengthInBytes count]) {
                testChar[i]=[[lengthInBytes objectAtIndex:i] intValue];
            }else {
                testChar[i]=0;
            }            
            //NSLog(@"%i",testChar[i]);
        }else if(i<(extensionBits+dataLengthBits)/8){
            testChar[i]=extensionArray[charExtensionIndex];
            charExtensionIndex++;
            //NSLog(@"Extension Character written: %i",testChar[i]);
        }else{
            testChar[i]=testCharTemp[i-(dataLengthBits+extensionBits)];
        }
    }
    
    /*Encryption*/
    NSArray *keyArray = [[NSArray alloc] initWithArray:NSStringToKeyArray(prepareStringForEncryption(keyString))];
    int j=0;
    for (int i=0; i<sizeof(testChar)/sizeof(unsigned char); i++) {
        testChar[i]=testChar[i]+[[keyArray objectAtIndex:j] intValue];
        if (j<[keyArray count]-1) {
            j++;
        }else {
            j=0;
        }
    }
    
    NSBitmapImageRep *imageBitmapRepOut = encryptInImage(imageBitmapRep, (char *)testChar, numberOfBits, dataLength);
    NSLog(@"Data has been succesfully encrypted!");
    free(extensionArray);
    return  imageBitmapRepOut; 
}
-(NSData *)decryptFileDataWithBits:(int)numberOfBits andStoreExtensionIn:(NSString **)extensionPtr andKey:(NSString *)keyString{
    /*Obtain the data hidden in the image as a bytes array*/
    NSArray *readStringTemp = [[NSArray alloc] initWithArray:decryptImageLinearly(imageBitmapRep, numberOfBits)];
    /*Decrypt*/
    NSMutableArray *readString = [[NSMutableArray alloc] initWithArray:readStringTemp];
    NSArray *keyArray = [[NSArray alloc] initWithArray:NSStringToKeyArray(prepareStringForEncryption(keyString))];
    NSArray *phased = [[NSArray alloc] initWithArray:unphasedArray(readString,keyArray)];
    /*Convert read array into NSData object*/
    NSString *readExtension = [[NSString alloc] init];
    NSData *dataOutput = [[NSData alloc] initWithData:NSArrayToDataWithExtension(phased, &readExtension)];
    *extensionPtr = readExtension;
    return dataOutput;
}

@end