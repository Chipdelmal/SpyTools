//
//  HSImageEncryptor.m
//  SpyTools
//
//  Created by Chip on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSImageEncryptor.h"

@implementation HSImageEncryptor
@synthesize imageBitmapRep;
@synthesize imageWidth;
@synthesize imageHeight;

/*Initializers*/
-(id)init{
    return [self initWithData:NULL];
}
-(id)initWithData:(NSData *)imageData{
    self = [super init];
    if(self){
        [self setImageBitmapRep:[[NSBitmapImageRep alloc] initWithData:imageData]];
        [self setImageWidth:CGImageGetWidth([imageBitmapRep CGImage])];
        [self setImageHeight:CGImageGetHeight([imageBitmapRep CGImage])];
        NSLog(@"[%i,%i]", imageWidth, imageHeight);
    }
    return self;
}
/*Action Methods*/
-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andComponents:(int)numberOfComponents andString:(NSString *)stringToBeEncrypted{
    
    char *testChar = NSStringToCharArray(prepareStringForEncryption(stringToBeEncrypted));
    int sizeOfString = strlen(testChar);
    
    unsigned long tempPixelValues[numberOfComponents];
    
    int characterBitsIndex = 0;
    int characterNumberIndex = 0;
    
    NSMutableArray *characterBinary = [[NSMutableArray alloc] initWithArray:characterToBinaryArray(testChar[characterNumberIndex], numberOfBits)];
    for (int j=0; j<imageHeight; j++) {
        for (int i=0; i<imageWidth; i++) {
            /*Get current index components*/
            [[self imageBitmapRep] getPixel:tempPixelValues atX:i y:j];
            /*Process pixel's color components*/
            for (int k=0; k<numberOfComponents; k++) {
                
                /*Check if character bit index is higher or equal to the number of allowed bits*/
                if (characterBitsIndex>=(numberOfBits)) {
                    /*Reset bit index and increment character index*/
                    characterBitsIndex = 0;
                    characterNumberIndex++;
                    /*Move to next character*/
                    characterBinary = characterToBinaryArray(testChar[characterNumberIndex], numberOfBits);
                }
                
                /*Conversion of color component to binary array*/
                NSArray *tempComponentBitArray = [[NSArray alloc] initWithArray:characterToBinaryArray(tempPixelValues[k], numberOfBits)];
                /*Modification of the original pixel according to the character's current bit*/
                NSArray *tempModifiedBitArray = [[NSArray alloc] initWithArray:setBitWithArrayValue(tempComponentBitArray, characterBinary, characterBitsIndex, 0)];
                /*Conversion of the color component's bits to an integer and assignement to the components array*/
                tempPixelValues[k]=binaryArrayToCharacter(tempModifiedBitArray, numberOfBits);
                
                /*Check if the string has ended so that the array is repeated*/
                if (characterNumberIndex>=sizeOfString) {
                    characterNumberIndex = 0;
                }
                characterBitsIndex++;
            }
            
            [[self imageBitmapRep] setPixel:tempPixelValues atX:i y:j];
        }
    }
    free(testChar);
    NSLog(@"Data has been succesfully encrypted!");
    //NSData *dataOutput = [[self imageBitmapRep] representationUsingType:NSPNGFileType properties:nil];
    return [self imageBitmapRep];
}
-(NSString *)decryptImageWithBits:(int)numberOfBits andComponents:(int)numberOfComponents{
    
    /*Declaration of reading variables*/
    unsigned long readTempPixelValues[numberOfComponents];
    NSMutableArray *readString = [[NSMutableArray alloc] init];
    NSMutableArray *readCharacterBinary = [[NSMutableArray alloc] initWithCapacity:numberOfBits];
    NSArray *readComponent = [[NSArray alloc] init];
    
    int readCharacterIndex = 0; 
    /*-----Read characters from image-----*/
    for (int j=0; j<imageHeight; j++){
        for (int i=0; i<imageWidth; i++) {
            
            /*Read current pixel's component values*/
            [imageBitmapRep getPixel:readTempPixelValues atX:i y:j];
            
            /*Add components LSB to character array*/
            for(int k=0; k<numberOfComponents; k++){
                readComponent = characterToBinaryArray(readTempPixelValues[k], numberOfBits);
                [readCharacterBinary insertObject:[readComponent objectAtIndex:0] atIndex:readCharacterIndex];
                
                if (readCharacterIndex>=7) {
                    [readString addObject:[NSNumber numberWithInt:binaryArrayToCharacter(readCharacterBinary, numberOfBits)]];
                    readCharacterIndex = 0;
                }else {
                    readCharacterIndex++;                
                }
            }
        }
    }
    
    NSString *readNSString = [[NSString alloc] initWithCString:NSArrayToCharArray(readString) encoding:4];
    return readNSString;
}

-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andComponents:(int)numberOfComponents andData:(NSData *)dataToBeEncrypted{
    
    //char *testChar = NSStringToCharArray(prepareStringForEncryption(stringToBeEncrypted));
    unsigned char testChar[[dataToBeEncrypted length]];
     [dataToBeEncrypted getBytes:testChar];
    int sizeOfString = [dataToBeEncrypted length];
    
    unsigned long tempPixelValues[numberOfComponents];
    
    int characterBitsIndex = 0;
    int characterNumberIndex = 0;
    
    NSMutableArray *characterBinary = [[NSMutableArray alloc] initWithArray:characterToBinaryArray(testChar[characterNumberIndex], numberOfBits)];
    for (int j=0; j<imageHeight; j++) {
        for (int i=0; i<imageWidth; i++) {
            /*Get current index components*/
            [[self imageBitmapRep] getPixel:tempPixelValues atX:i y:j];
            /*Process pixel's color components*/
            for (int k=0; k<numberOfComponents; k++) {
                /*Check if character bit index is higher or equal to the number of allowed bits*/
                if (characterBitsIndex>=(numberOfBits)) {
                    /*Reset bit index and increment character index*/
                    characterBitsIndex = 0;
                    characterNumberIndex++;
                    /*Move to next character*/
                    characterBinary = characterToBinaryArray(testChar[characterNumberIndex], numberOfBits);
                }
                
                /*Conversion of color component to binary array*/
                NSArray *tempComponentBitArray = [[NSArray alloc] initWithArray:characterToBinaryArray(tempPixelValues[k], numberOfBits)];
                /*Modification of the original pixel according to the character's current bit*/
                NSArray *tempModifiedBitArray = [[NSArray alloc] initWithArray:setBitWithArrayValue(tempComponentBitArray, characterBinary, characterBitsIndex, 0)];
                /*Conversion of the color component's bits to an integer and assignement to the components array*/
                tempPixelValues[k]=binaryArrayToCharacter(tempModifiedBitArray, numberOfBits);
                
                //NSLog(@"[%i,%i,%@]", binaryArrayToCharacter(tempComponentBitArray,8), binaryArrayToCharacter(tempModifiedBitArray, 8), [characterBinary objectAtIndex:characterBitsIndex]);
                
                /*Check if the string has ended so that the array is repeated*/
                if (characterNumberIndex>=sizeOfString) {
                    characterNumberIndex = 0;
                }
                characterBitsIndex++;
            }
            
            [[self imageBitmapRep] setPixel:tempPixelValues atX:i y:j];
        }
    }
    //free(testChar);
    NSLog(@"Data has been succesfully encrypted!");
    //NSData *dataOutput = [[self imageBitmapRep] representationUsingType:NSPNGFileType properties:nil];
    return [self imageBitmapRep];
}
-(NSArray *)decryptImageDataWithBits:(int)numberOfBits andComponents:(int)numberOfComponents{
    
    /*Declaration of reading variables*/
    unsigned long readTempPixelValues[numberOfComponents];
    NSMutableArray *readString = [[NSMutableArray alloc] init];
    NSMutableArray *readCharacterBinary = [[NSMutableArray alloc] initWithCapacity:numberOfBits];
    NSArray *readComponent = [[NSArray alloc] init];
    
    int readCharacterIndex = 0; 
    /*-----Read characters from image-----*/
    for (int j=0; j<imageHeight; j++){
        for (int i=0; i<imageWidth; i++) {
            
            /*Read current pixel's component values*/
            [imageBitmapRep getPixel:readTempPixelValues atX:i y:j];
            
            /*Add components LSB to character array*/
            for(int k=0; k<numberOfComponents; k++){
                readComponent = characterToBinaryArray(readTempPixelValues[k], numberOfBits);
                [readCharacterBinary insertObject:[readComponent objectAtIndex:0] atIndex:readCharacterIndex];
                
                if (readCharacterIndex>=7) {
                    [readString addObject:[NSNumber numberWithInt:binaryArrayToCharacter(readCharacterBinary, numberOfBits)]];
                    readCharacterIndex = 0;
                }else {
                    readCharacterIndex++;                
                }
            }
        }
    }
    
    return readString;
}


@end
