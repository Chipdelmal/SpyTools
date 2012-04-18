//
//  HSImageEncryptor.h
//  SpyTools
//
//  Created by Chip on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCryptoFunctions.h"

@interface HSImageEncryptor : NSObject{
    int                 imageHeight;
    int                 imageWidth;
    NSBitmapImageRep    *imageBitmapRep;
}
/*Initializers*/
-(id)init;
-(id)initWithData:(NSData *)imageData;
/*Action Methods*/
-(NSBitmapImageRep *)encryptImageWithBits:(int)numberOfBits andComponents:(int)numberOfComponents andString:(NSString *)stringToBeEncrypted; 
-(NSString *)decryptImageWithBits:(int)numberOfBits andComponents:(int)numberOfComponents; 


@property (strong) NSBitmapImageRep *imageBitmapRep;
@property int imageHeight;
@property int imageWidth;

@end
