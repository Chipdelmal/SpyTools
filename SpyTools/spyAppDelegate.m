//
//  spyAppDelegate.m
//  SpyTools
//
//  Created by Chip on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "spyAppDelegate.h"

@implementation spyAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [processActionSelector setSelectedSegment:0];
    [informationLabel setStringValue:@"Enter the text to be encrypted."];
    [stProgressIndicator setHidden:TRUE];
    [sendToSteganographyButton setEnabled:FALSE];
    [stSendToTextButton setEnabled:FALSE];
    
    stTextFits = FALSE;
    
    [self processActionSelectorChange:self];
    [self processSequence:self];
    
    /*Debug*/
    /*Encryption Operations*/
    NSData *imageToEncryptIn = [[NSData alloc] initWithContentsOfFile:@"/Users/Chip/Pictures/lena.bmp"];
    NSData *imageToBeEncrypted = [[NSData alloc] initWithContentsOfFile:@"/Users/Chip/Pictures/Test5.png"];
    
    HSImageEncryptor *imageEncryptorObject = [[HSImageEncryptor alloc] initWithData:imageToEncryptIn];
    NSBitmapImageRep *imageEncryptedBitmap = [imageEncryptorObject encryptImageWithBits:8 andComponents:3 andData:imageToBeEncrypted];
    
    NSData *encryptedImageOutput = [imageEncryptedBitmap representationUsingType:NSBMPFileType properties:nil];
    [encryptedImageOutput writeToFile:@"/Users/Chip/Pictures/encrypted.bmp" atomically:NO];
    
    /*Decryption Operations*/
    HSImageEncryptor *imageEncryptedObject = [[HSImageEncryptor alloc] initWithData:encryptedImageOutput];
    NSArray *decryptedImageArray = [imageEncryptedObject decryptImageDataWithBits:8 andComponents:3];
    //NSLog(@"%@",decryptedImageArray);
    
    NSMutableArray *lengthArray = [[NSMutableArray alloc] init];
    for (int i=0; i<30; i++) {
        [lengthArray addObject:[decryptedImageArray objectAtIndex:i]];
    }
    int dataLength = binaryArrayToCharacter(lengthArray, 30);
    //NSLog(@"%i",dataLength);
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (int k=30; k<[decryptedImageArray count]; k++) {
        [dataArray addObject:[decryptedImageArray objectAtIndex:k]];
    }
    NSLog(@"%@",dataArray);
    
    
    /*Tests*/
    unsigned char inputBuffer[[imageToBeEncrypted length]];
    [imageToBeEncrypted getBytes:inputBuffer];
    
    unsigned char outputBuffer[[imageToBeEncrypted length]];
    //*outputBuffer = NSArrayToUnsignedCharArray(decryptedImageArray);
    for (int i=0; i<dataLength; i++) {
        outputBuffer[i]=[[dataArray objectAtIndex:i] intValue];
        //NSLog(@"IO: [%i,%@,%i]@%i",inputBuffer[i],[decryptedImageArray objectAtIndex:i],outputBuffer[i],i);
    }
    
    NSData *dataOutput = [[NSData alloc] initWithBytes:outputBuffer length:[imageToBeEncrypted length]];
    [dataOutput writeToFile:@"/Users/Chip/Pictures/decrypted.png" atomically:NO];
}
/*Global*/
-(IBAction)processActionSelectorChange:(id)sender{
    [self processSequence:self];
}
-(IBAction)clearInterface:(id)sender{
    [textToProcessField setStringValue:@""];
    [keyField setStringValue:@""];
    [keyLengthTextField setStringValue:@""];
    [maxRandomValueField setStringValue:@""];
    [textProcessedField setStringValue:@""];
    [stTextProcessedField setStringValue:@""];
    [stTextToProcessField setStringValue:@""];
    [stInputImageWell setImage:NULL];
    [self processActionSelectorChange:self];
}
-(IBAction)processSequence:(id)sender{
    if ([processActionSelector selectedSegment]==0) {
        NSLog(@"Interface: Text Encryption Selected");
        [processButton setTitle:@"Encrypt"];
        [stProcessButton setTitle:@"Encrypt"];
        [textToProcessField setTextColor:[NSColor blackColor]];
        [textProcessedField setTextColor:[NSColor blackColor]];
        [self textEncryptionSequence:self];
        [self textImageEncryptionSequence:self];
    }else if([processActionSelector selectedSegment]==1){
        NSLog(@"Interface: Text Decryption Selected");
        [processButton setTitle:@"Decrypt"];
        [stProcessButton setTitle:@"Decrypt"];
        [textToProcessField setTextColor:[NSColor blackColor]];
        [textProcessedField setTextColor:[NSColor blackColor]];
        [self textDecryptionSequence:self];
        [self textImageDecryptionSequence:self];
    }
}
-(IBAction)textEncryptionSequence:(id)sender{
    NSLog(@"Interface: Text Encryption Sequence");
    if ([[textToProcessField stringValue] length]==0){
        [informationLabel setStringValue:@"Enter a text to encrypt and press Enter."];
        NSLog(@"Interface: No text entered.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:FALSE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
        [generateRandomPassphraseButton setEnabled:FALSE];
    }else if([[keyField stringValue] length]==0){
        [informationLabel setStringValue:@"Enter an encryption key or generate one."];
        NSLog(@"Interface: No key entered.");
        [keyLengthTextField setEnabled:TRUE];
        [maxRandomValueField setEnabled:TRUE];
        [generateRandomKeyButton setEnabled:TRUE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
        [self autoGenerateRandomKeyParameters:self];
        [generateRandomPassphraseButton setEnabled:TRUE];
    }else if([[textProcessedField stringValue] length]==0){
        [informationLabel setStringValue:@"Ready to process."];
        NSLog(@"Interface: Ready to Process.");
        [keyLengthTextField setEnabled:TRUE];
        [maxRandomValueField setEnabled:TRUE];
        [generateRandomKeyButton setEnabled:TRUE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:TRUE];
        [textProcessedField setEnabled:TRUE];
        [generateRandomPassphraseButton setEnabled:TRUE];
    }else {
        [informationLabel setStringValue:@"Your text has been processed."];
        NSLog(@"Interface: Text processed.");
    }
    
    if (([[textProcessedField stringValue] length]!=0)&&([processActionSelector selectedSegment]==0)) {
        [sendToSteganographyButton setEnabled:TRUE];
    }else {
        [sendToSteganographyButton setEnabled:FALSE];
    }
}
-(IBAction)textDecryptionSequence:(id)sender{
    NSLog(@"Interface: Text Decryption Sequence");
    if ([[textToProcessField stringValue] length]==0) {
        [informationLabel setStringValue:@"Enter a text to decrypt and press Enter."];
        NSLog(@"Interface: No text entered.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:FALSE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
        [generateRandomPassphraseButton setEnabled:FALSE];
    }else if([[keyField stringValue] length]==0){
        [informationLabel setStringValue:@"Enter a decryption key and press Enter."];
        NSLog(@"Interface: No key entered.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
        [generateRandomPassphraseButton setEnabled:FALSE];
    }else {
        [informationLabel setStringValue:@"Ready to process."];
        NSLog(@"Interface: Ready to Process.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:TRUE];
        [textProcessedField setEnabled:TRUE];
        [generateRandomPassphraseButton setEnabled:FALSE];
    }
}
-(IBAction)textImageEncryptionSequence:(id)sender{
    if ([[stTextToProcessField stringValue] length]==0) {
        NSLog(@"Interface: Text to encrypt has not been entered.");
        [stTextToProcessField setEnabled:TRUE];
        [stTextProcessedField setEnabled:FALSE];
        [stInputImageWell setEnabled:FALSE];
        [stImageFormatSelector setEnabled:FALSE];
        [stAnalyzeLabel setHidden:TRUE];
        [stProcessButton setEnabled:FALSE];
        [informationLabel setStringValue:@"Enter a text to be encrypted and press Enter."];
    }else if(([[stTextToProcessField stringValue] length]!=0)&&([stInputImageWell image]==NULL)){
        NSLog(@"Interface: Image has not been entered.");
        [stInputImageWell setEnabled:TRUE];
        [stTextProcessedField setEnabled:FALSE];
        [stImageFormatSelector setEnabled:FALSE];
        [stAnalyzeLabel setHidden:TRUE];
        [stProcessButton setEnabled:FALSE];
        [informationLabel setStringValue:@"Drag and drop an image to the container."];
    }else if (([[stTextToProcessField stringValue] length]!=0)&&([stInputImageWell image]!=NULL)) {
        NSLog(@"Interface: Image is ready.");
        [stImageFormatSelector setEnabled:TRUE];
        [stTextProcessedField setEnabled:FALSE];
        [self analyzeSpace:self];
        [stAnalyzeLabel setHidden:FALSE];
        if (stTextFits) {
            [stProcessButton setEnabled:TRUE];
            [informationLabel setStringValue:@"The text is ready to be encrypted."];
        }else {
            [informationLabel setStringValue:@"The text does not fit selected image."];
        }
    }else {
        [informationLabel setStringValue:@"Your text has been encrypted."];
    }
}
-(IBAction)textImageDecryptionSequence:(id)sender{
    [stImageFormatSelector setEnabled:FALSE];
    [stInputImageWell setEnabled:TRUE];
    [stTextToProcessField setEnabled:FALSE];
    if([stInputImageWell image]==NULL){
        [stProcessButton setEnabled:FALSE];
        [informationLabel setStringValue:@"Drag and drop the encrypted image to the container."];
    }else {
        [stTextProcessedField setEnabled:TRUE];
        [stProcessButton setEnabled:TRUE];
        [informationLabel setStringValue:@"Image is ready to be decrypted."];
    }
    
    if (([[stTextProcessedField stringValue] length]!=0)&&([processActionSelector selectedSegment]!=0)) {
        [stSendToTextButton setEnabled:TRUE];
    }else {
        [stSendToTextButton setEnabled:FALSE];
    }
    
}
/*Text encryption*/
-(IBAction)generateRandomPassphrase:(id)sender{
    HSKeyLibrary *keyObject = [[HSKeyLibrary alloc] initWithFileName:@"1984"];
    NSString *encryptionString = [[keyObject keysArray] objectAtIndex:(arc4random()%[[keyObject keysArray] count])];
    [keyField setStringValue:encryptionString];
    [self textEncryptionSequence:self];
}
-(IBAction)generateRandomKey:(id)sender{
    NSArray *keyArray = generateRandomPad([keyLengthTextField intValue], [maxRandomValueField intValue]);
    NSString *keyString = padArrayToString(keyArray);
    [keyField setStringValue:keyString];
    [self textEncryptionSequence:self];
}
-(IBAction)autoGenerateRandomKeyParameters:(id)sender{
    int keyLength = [[textToProcessField stringValue] length];
    [keyLengthTextField setIntValue:keyLength];
    [maxRandomValueField setIntValue:(122-65)];
}
-(IBAction)processText:(id)sender{
    if ([processActionSelector selectedSegment]==0) {
        [self encryptText:self];
    }else {
        [self decryptText:self];
    }
}
-(IBAction)encryptText:(id)sender{
    NSLog(@"Interface: Encryption Started");
    NSString *stringToProcess = [textToProcessField stringValue];
    NSString *keyString = [keyField stringValue];    
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToProcess];
    NSString *encryptedString = [[NSString alloc] init];
    
    if([keyTypeTabView indexOfTabViewItem:[keyTypeTabView selectedTabViewItem]]==1){
        encryptedString = [encryptorObject encryptStringToProcessWithKey:keyString];
    }else {
        encryptedString = [encryptorObject encryptStringToProcessWithPassphrase:keyString];
    }
        
    NSLog(@"Interface: Encryption Finished With result [%@]", encryptedString);
    [textProcessedField setStringValue:encryptedString];
    [self textEncryptionSequence:self];
}
-(IBAction)decryptText:(id)sender{
    NSLog(@"Interface: Encryption Started");
    NSString *stringToProcess = [textToProcessField stringValue];
    NSString *keyString = [keyField stringValue];
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToProcess];
    NSString *decryptedString = [[NSString alloc] init];
    
    if ([keyTypeTabView indexOfTabViewItem:[keyTypeTabView selectedTabViewItem]]==1) {
        decryptedString = [encryptorObject decryptStringToProcessWithKey:keyString];
    }else {
        decryptedString = [encryptorObject decryptStringToProcessWithPassphrase:keyString];
    }
    
    NSLog(@"Interface: Decryption Finished With result [%@]", decryptedString);
    [textProcessedField setStringValue:decryptedString];
    [self textDecryptionSequence:self];
}
-(IBAction)sendResultToImage:(id)sender{
    [stTextToProcessField setStringValue:[textProcessedField stringValue]];
    [tabView selectTabViewItem:[tabView tabViewItemAtIndex:1]];
    [processActionSelector setSelectedSegment:0];
}
/*Text in Image encryption*/
-(IBAction)analyzeSpace:(id)sender{
    NSData *imageData = [[NSData alloc] initWithData:[[stInputImageWell image] TIFFRepresentation]];
    HSImageEncryptor *imageObject = [[HSImageEncryptor alloc] initWithData:imageData];
    int pixelsNumber = [imageObject imageWidth]*[imageObject imageHeight];
    int charactersNumber = pixelsNumber / 8;
    int inputStringSize = [[stTextToProcessField stringValue] length];
    NSString *warningString = [[NSString alloc] initWithString:@"Test"];
    if (inputStringSize<charactersNumber) {
        [processButton setEnabled:TRUE];
        stTextFits = TRUE;
        warningString = @"Text fits the image.";
    }else {
        [processButton setEnabled:FALSE];
        stTextFits = FALSE;
        warningString = @"Text does not fit the image. Please select a bigger image or a shorter text.";
    }
    
    NSString *analyzeStringLabel = [[NSString alloc] initWithFormat:@"Number of pixels: %i \nNumber of characters allowed: %i \nString Size: %i \n\n%@",pixelsNumber,charactersNumber, inputStringSize,warningString];
    [stAnalyzeLabel setStringValue:analyzeStringLabel];
}
-(IBAction)encryptTextImage:(id)sender{
    [informationLabel setStringValue:@"Working. Please wait."];
    [stProgressIndicator setHidden:FALSE];
    [stProgressIndicator startAnimation:self];

    NSData *imageData = [[NSData alloc] initWithData:[[stInputImageWell image] TIFFRepresentation]];
    HSImageEncryptor    *imageObject = [[HSImageEncryptor alloc] initWithData:imageData];
    NSBitmapImageRep    *bitmapRep = [imageObject encryptImageWithBits:8 andComponents:3 andString:[stTextToProcessField stringValue]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory,NSUserDomainMask, YES);
    NSString *desktopPath = [paths objectAtIndex:0];
    NSLog(@"%@",desktopPath);
    
    
    if([stImageFormatSelector selectedSegment]==0){
        NSData *dataOutput = [bitmapRep representationUsingType:NSBMPFileType properties:nil];
        NSString *fullWriteString = [[NSString alloc] initWithFormat:@"%@/%@",desktopPath,@"EncryptedImage.bmp"];
        [dataOutput writeToFile:fullWriteString atomically: NO]; 
    }else if([stImageFormatSelector selectedSegment]==1){
        NSData *dataOutput = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
        NSString *fullWriteString = [[NSString alloc] initWithFormat:@"%@/%@",desktopPath,@"EncryptedImage.png"];
        [dataOutput writeToFile:fullWriteString atomically: NO];
    }else if ([stImageFormatSelector selectedSegment]==2) {
        NSData *dataOutput = [bitmapRep representationUsingType:NSTIFFFileType properties:nil];
        NSString *fullWriteString = [[NSString alloc] initWithFormat:@"%@/%@",desktopPath,@"EncryptedImage.tiff"];
        [dataOutput writeToFile:fullWriteString atomically: NO];
    }
    
    [informationLabel setStringValue:@"Image succesfully encrypted and saved on your desktop."];
    [stProgressIndicator setHidden:TRUE];
    [stProgressIndicator stopAnimation:self];
    [self textImageEncryptionSequence:self];
}
-(IBAction)decryptTextImage:(id)sender{
    [informationLabel setStringValue:@"Working. Please wait."];
    [stProgressIndicator setHidden:FALSE];
    [stProgressIndicator startAnimation:self];
   
    NSData *imageData = [[NSData alloc] initWithData:[[stInputImageWell image] TIFFRepresentation]];
    HSImageEncryptor  *imageObject2 = [[HSImageEncryptor alloc] initWithData:imageData];
    NSString *stringOutput = [[NSString alloc] initWithString:[imageObject2 decryptImageWithBits:8 andComponents:3]];
    NSLog(@"%@",stringOutput);
    [stTextProcessedField setStringValue:stringOutput];
    
    [stProgressIndicator setHidden:TRUE];
    [stProgressIndicator stopAnimation:self];
    [informationLabel setStringValue:@"Text successfully decrypted."];
    [self textImageDecryptionSequence:self];
}
-(IBAction)processTextImage:(id)sender{
    if ([processActionSelector selectedSegment]==0) {
        NSLog(@"Encrypting...");
        [self encryptTextImage:self];
    }else {
        NSLog(@"Decrypting...");
        [self decryptTextImage:self];
    }
}
-(IBAction)sendResultToText:(id)sender{
    [textToProcessField setStringValue:[stTextProcessedField stringValue]];
    [tabView selectTabViewItem:[tabView tabViewItemAtIndex:0]];
    [processActionSelector setSelectedSegment:1];
}
@end
