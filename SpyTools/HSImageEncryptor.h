//
//  HSImageEncryptor.h
//  SpyTools
//
//  Created by Chip on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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


@property (strong) NSBitmapImageRep *imageBitmapRep;
@property int imageHeight;
@property int imageWidth;
@property int bitsPerPixel;
@property int numberOfComponents;

@end
