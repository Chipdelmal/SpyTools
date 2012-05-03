//
//  HSImageEncryptor.h
//  SpyTools
//
//  Created by Chip on 4/18/12.
//  Copyright (c) 2012 __Héctor Sánchez__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCryptoFunctions.h"

#define dataLengthBits        30

@interface HSImageEncryptor : NSObject{
    int                 imageHeight;
    int                 imageWidth;
    NSBitmapImageRep    *imageBitmapRep;
    int                 bitsPerPixel;
    int                 numberOfComponents;
}
/*Initializers*/
-(id)init;
-(id)initWithData:(NSData *)imageData;
/*Action Methods*/
-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andString:(NSString *)stringToBeEncrypted; 
-(NSString *)decryptImageWithBits:(int)numberOfBits; 

-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andData:(NSData *)dataToBeEncrypted; 
-(NSData *)decryptImageDataWithBits:(int)numberOfBits; 


@property (strong, readonly) NSBitmapImageRep *imageBitmapRep;
@property (readonly) int imageHeight;
@property (readonly) int imageWidth;
@property (readonly) int bitsPerPixel;
@property (readonly) int numberOfComponents;

@end
