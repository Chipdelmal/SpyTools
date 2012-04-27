//
//  spyAppDelegate.m
//  SpyTools
//
//  Created by Chip on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "spyAppDelegate.h"

@implementation spyAppDelegate
@synthesize tiOperationSelector;
@synthesize tiKeyTypeSelector;
@synthesize tiInputTextField;
@synthesize tiInputImageWell;
@synthesize tiKeyLengthSelector;
@synthesize tiKeyTextField;
@synthesize tiGenerateKeyButton;
@synthesize tiProcessButton;
@synthesize tiOutputTextField;
@synthesize tiInputTextLabel;
@synthesize tiOutputTextLabel;
@synthesize tiProgressIndicator;
@synthesize tiOutputFormatSelector;
@synthesize teOperationSelector;
@synthesize teInputTextField;
@synthesize teKeyTypeSelector;
@synthesize teKeyLengthSelector;
@synthesize teGenerateKeyButton;
@synthesize teProcessButton;
@synthesize teOutputText;
@synthesize teInformationLabel;
@synthesize teRandomKeyBox;
@synthesize teKeyTextField;
@synthesize teKeyTypeLabel;
@synthesize teKeyLengthLabel;
@synthesize teInputTextLabel;
@synthesize teKeyFieldLabel;
@synthesize teOutputTextLabel;
@synthesize glTabView;

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [self operationSelectorChange:self];
    [self keyTypeSelectorChange:self];
}
/*Interface Methods*/
-(IBAction)operationSelectorChange:(id)sender{
    [self keyTypeSelectorChange:self];
    if ([teOperationSelector selectedSegment]==0) {
        [teKeyTypeSelector setEnabled:TRUE];
        [teKeyLengthSelector setEnabled:TRUE];
        [teGenerateKeyButton setEnabled:TRUE];
        [teProcessButton setTitle:@"Encrypt"];
        [teKeyFieldLabel setStringValue:@"Encryption Key:"];
        [teKeyLengthLabel setEnabled:TRUE];
        [teKeyTypeLabel setEnabled:TRUE];
        [teInputTextLabel setStringValue:@"Text to be Encrypted:"];
        [teOutputTextLabel setStringValue:@"Encrypted Text:"];
    }else {
        [teKeyTypeSelector setEnabled:FALSE];
        [teKeyLengthSelector setEnabled:FALSE];
        [teGenerateKeyButton setEnabled:FALSE];
        [teProcessButton setTitle:@"Decrypt"];
        [teKeyFieldLabel setStringValue:@"Decryption Key:"];
        [teKeyLengthLabel setEnabled:FALSE];
        [teKeyTypeLabel setEnabled:FALSE];
        [teInputTextLabel setStringValue:@"Text to be Decrypted:"];
        [teOutputTextLabel setStringValue:@"Decrypted Text:"];
    }
}
-(IBAction)keyTypeSelectorChange:(id)sender{
    if (([teKeyTypeSelector selectedSegment]==0)&&([teOperationSelector selectedSegment]==0)) {
        [teKeyLengthSelector setEnabled:TRUE];
    }else {
        [teKeyLengthSelector setEnabled:FALSE];
    }
}
/*Text Encryption*/
-(IBAction)generateRandomKey:(id)sender{
    int inputStringLength = [[teInputTextField stringValue] length];
    float lengthFraction = 1;
    if ([teKeyLengthSelector selectedSegment]==0) {
        lengthFraction = 1;
    }else if ([teKeyLengthSelector selectedSegment]==1) {
        lengthFraction = .5;
    }else {
        lengthFraction = .25;
    }
    int keyLength = lengthFraction*inputStringLength;
    NSArray *randomlyGeneratedKey = generateRandomPad(keyLength, 122-32);
    [teKeyTextField setStringValue:padArrayToString(randomlyGeneratedKey)];
    
    //NSLog(@"[Input String Length: %i :: Key Length: %i]", inputStringLength, keyLength);
}
-(IBAction)generateRandomPassphrase:(id)sender{
    HSKeyLibrary *keyObject = [[HSKeyLibrary alloc] initWithFileName:@"1984"];
    NSString *encryptionString = [[keyObject keysArray] objectAtIndex:(arc4random()%[[keyObject keysArray] count])];
    [teKeyTextField setStringValue:encryptionString];
}
-(IBAction)generateKeySelector:(id)sender{
    if ([teKeyTypeSelector selectedSegment]==0) {
        [self generateRandomKey:self];
    }else {
        [self generateRandomPassphrase:self];
    }
}
-(IBAction)oneTimePadEncryptText:(id)sender{
    NSString *stringToEncrypt = [[NSString alloc] initWithString:[teInputTextField stringValue]];
    NSString *keyString = [[NSString alloc] initWithString:[teKeyTextField stringValue]];
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToEncrypt];
    NSString *encryptedString = [encryptorObject encryptProcessAutoSelector:keyString];
    [teOutputText setStringValue:encryptedString];
}
-(IBAction)onetimePadDecryptText:(id)sender{
    NSString *stringToDecrypt = [[NSString alloc] initWithString:[teInputTextField stringValue]];
    NSString *keyString = [[NSString alloc] initWithString:[teKeyTextField stringValue]];
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToDecrypt];
    NSString *decryptedString = [encryptorObject decryptProcessAutoSelector:keyString];
    [teOutputText setStringValue:decryptedString]; 
}
-(IBAction)oneTimePadSelector:(id)sender{
    if ([teOperationSelector selectedSegment]==0) {
        [self oneTimePadEncryptText:self];
    }else {
        [self onetimePadDecryptText:self];
    }
}
/*Text in Image Encryption*/
-(IBAction)tiGenerateRandomKey:(id)sender{
    int inputStringLength = [[tiInputTextField stringValue] length];
    float lengthFraction = 1;
    if ([tiKeyLengthSelector selectedSegment]==0) {
        lengthFraction = 1;
    }else if ([tiKeyLengthSelector selectedSegment]==1) {
        lengthFraction = .5;
    }else {
        lengthFraction = .25;
    }
    int keyLength = lengthFraction*inputStringLength;
    NSArray *randomlyGeneratedKey = generateRandomPad(keyLength, 122-32);
    [tiKeyTextField setStringValue:padArrayToString(randomlyGeneratedKey)]; 
}
-(IBAction)tiGenerateRandomPassphrase:(id)sender{
    HSKeyLibrary *keyObject = [[HSKeyLibrary alloc] initWithFileName:@"1984"];
    NSString *encryptionString = [[keyObject keysArray] objectAtIndex:(arc4random()%[[keyObject keysArray] count])];
    [tiKeyTextField setStringValue:encryptionString];
}
-(IBAction)tiGenerateKeySelector:(id)sender{
    if ([tiKeyTypeSelector selectedSegment]==0) {
        [self tiGenerateRandomKey:self];
    }else if([tiKeyTypeSelector selectedSegment]==1){
        [self tiGenerateRandomPassphrase:self];
    }
}
-(IBAction)tiOneTimePadEncryptText:(id)sender{
    NSString *stringToEncrypt = [[NSString alloc] initWithString:[tiInputTextField stringValue]];
    NSString *keyString = [[NSString alloc] initWithString:[tiKeyTextField stringValue]];
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToEncrypt];
    NSString *encryptedString = [encryptorObject encryptProcessAutoSelector:keyString];
    stringToProcess = encryptedString;
    [tiOutputTextField setStringValue:encryptedString];
}
-(IBAction)tiOnetimePadDecryptText:(id)sender{
    NSString *stringToDecrypt = [[NSString alloc] initWithString:stringToProcess];
    NSString *keyString = [[NSString alloc] initWithString:[tiKeyTextField stringValue]];
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToDecrypt];
    NSString *decryptedString = [encryptorObject decryptProcessAutoSelector:keyString];
    [tiOutputTextField setStringValue:decryptedString]; 
}
-(IBAction)tiOneTimePadSelector:(id)sender{
    if ([tiOperationSelector selectedSegment]==0) {
        [self tiOneTimePadEncryptText:self];
    }else {
        [self tiOnetimePadDecryptText:self];
    }
}
-(IBAction)tiEncryptSteganography:(id)sender{
    NSLog(@"Text in Image Steganography encryption started.");
    [self tiOneTimePadEncryptText:self];
    
    NSData *imageData = [[NSData alloc] initWithData:[[tiInputImageWell image] TIFFRepresentation]];
    HSImageEncryptor    *imageObject = [[HSImageEncryptor alloc] initWithData:imageData];
    NSBitmapImageRep    *bitmapRep = [imageObject encryptImageWithBits:8 andComponents:3 andString:stringToProcess];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory,NSUserDomainMask, YES);
    NSString *desktopPath = [paths objectAtIndex:0];
    
    if([tiOutputFormatSelector selectedSegment]==0){
        NSData *dataOutput = [bitmapRep representationUsingType:NSBMPFileType properties:nil];
        NSString *fullWriteString = [[NSString alloc] initWithFormat:@"%@/%@",desktopPath,@"EncryptedImage.bmp"];
        [dataOutput writeToFile:fullWriteString atomically: NO]; 
    }else if([tiOutputFormatSelector selectedSegment]==1){
        NSData *dataOutput = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
        NSString *fullWriteString = [[NSString alloc] initWithFormat:@"%@/%@",desktopPath,@"EncryptedImage.png"];
        [dataOutput writeToFile:fullWriteString atomically: NO];
    }else if ([tiOutputFormatSelector selectedSegment]==2) {
        NSData *dataOutput = [bitmapRep representationUsingType:NSTIFFFileType properties:nil];
        NSString *fullWriteString = [[NSString alloc] initWithFormat:@"%@/%@",desktopPath,@"EncryptedImage.tiff"];
        [dataOutput writeToFile:fullWriteString atomically: NO];
    }
    NSLog(@"Text in Image Steganography encryption finished.");
}
-(IBAction)tiDecryptSteganography:(id)sender{
    NSLog(@"Text in Image Steganography decryption started.");
    
    NSData *imageData = [[NSData alloc] initWithData:[[tiInputImageWell image] TIFFRepresentation]];
    HSImageEncryptor  *imageObject2 = [[HSImageEncryptor alloc] initWithData:imageData];
    NSString *stringOutput = [[NSString alloc] initWithString:[imageObject2 decryptImageWithBits:8 andComponents:3]];
    NSLog(@"%@",stringOutput);
    stringToProcess = stringOutput;
    NSLog(@"String to Decrypt: %@",stringToProcess);
    [tiOutputTextField setStringValue:stringOutput];
    
    [self tiOnetimePadDecryptText:self];
    
    NSLog(@"Text in Image Steganography decryption finished.");
}
-(IBAction)tiTextSteganographySelector:(id)sender{
    if ([tiOperationSelector selectedSegment]==0) {
        [self tiEncryptSteganography:self];
    }else {
        [self tiDecryptSteganography:self];
    }
}

@end
