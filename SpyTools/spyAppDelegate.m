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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [processActionSelector setSelectedSegment:0];
    [informationLabel setStringValue:@"Enter the text to be encrypted."];
    
    [self processActionSelectorChange:self];
    
    /*
    HSTextEncryptor *testObject = [[HSTextEncryptor alloc] initWithNSString:@"Testing Héctor init"];
    NSString *keyString = [[NSString alloc] initWithString:@"2,3,4,5"];
    //[testObject stringToProcess];
    [testObject stringLength];
    NSString *encryptedString = [testObject encryptStringToProcessWithKey:keyString];
    
    HSTextEncryptor *testObject2 = [[HSTextEncryptor alloc] initWithNSString:encryptedString];
    [testObject2 decryptStringToProcessWithKey:keyString];
     */
}
-(IBAction)processActionSelectorChange:(id)sender{
    [textToProcessField setStringValue:[textProcessedField stringValue]];
    [textProcessedField setStringValue:@""];
}
-(IBAction)processSequence:(id)sender{
    if ([processActionSelector selectedSegment]==0) {
        NSLog(@"Interface: Text Encryption Selected");
        [processButton setStringValue:@"Encrypt"];
        [textToProcessField setTextColor:[NSColor blackColor]];
        [textProcessedField setTextColor:[NSColor blueColor]];
        //[textToProcessField setStringValue:@""];
        //[keyField setStringValue:@""];
        //[textProcessedField setStringValue:@""];
        [self textEncryptionSequence:NULL];
    }else if([processActionSelector selectedSegment]==1){
        NSLog(@"Interface: Text Decryption Selected");
        [processButton setStringValue:@"Decrypt"];
        [textToProcessField setTextColor:[NSColor blueColor]];
        [textProcessedField setTextColor:[NSColor blackColor]];
        //[textToProcessField setStringValue:@""];
        //[keyField setStringValue:@""];
        //[textProcessedField setStringValue:@""];
        [self textDecryptionSequence:NULL];
    }
}
-(IBAction)textEncryptionSequence:(id)sender{
    NSLog(@"Interface: Text Encryption Sequence");
    //NSLog(@"Interface: TextToProcess String: '%@'",[textToProcessField stringValue]);
    if ([[textToProcessField stringValue] length]==0){
        [informationLabel setStringValue:@"Enter a text to encrypt and press Enter."];
        NSLog(@"Interface: No text entered.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [textLengthButton setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:FALSE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
    }else if([[keyField stringValue] length]==0){
        [informationLabel setStringValue:@"Enter an encryption key or generate one."];
        NSLog(@"Interface: No key entered.");
        [keyLengthTextField setEnabled:TRUE];
        [maxRandomValueField setEnabled:TRUE];
        [textLengthButton setEnabled:TRUE];
        [generateRandomKeyButton setEnabled:TRUE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
        [self autoGenerateRandomKeyParameters:self];
    }else if([[textProcessedField stringValue] length]==0){
        [informationLabel setStringValue:@"Ready to process."];
        NSLog(@"Interface: Ready to Process.");
        [keyLengthTextField setEnabled:TRUE];
        [maxRandomValueField setEnabled:TRUE];
        [textLengthButton setEnabled:TRUE];
        [generateRandomKeyButton setEnabled:TRUE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:TRUE];
        [textProcessedField setEnabled:TRUE];
    }else {
        [informationLabel setStringValue:@"Your text has been processed."];
        NSLog(@"Interface: Text processed.");
    }
}
-(IBAction)textDecryptionSequence:(id)sender{
    NSLog(@"Interface: Text Decryption Sequence");
    if ([[textToProcessField stringValue] length]==0) {
        [informationLabel setStringValue:@"Enter a text to decrypt and press Enter."];
        NSLog(@"Interface: No text entered.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [textLengthButton setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:FALSE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
    }else if([[keyField stringValue] length]==0){
        [informationLabel setStringValue:@"Enter a decryption key and press Enter."];
        NSLog(@"Interface: No key entered.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [textLengthButton setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:FALSE];
        [textProcessedField setEnabled:FALSE];
    }else {
        [informationLabel setStringValue:@"Ready to process."];
        NSLog(@"Interface: Ready to Process.");
        [keyLengthTextField setEnabled:FALSE];
        [maxRandomValueField setEnabled:FALSE];
        [textLengthButton setEnabled:FALSE];
        [generateRandomKeyButton setEnabled:FALSE];
        [keyField setEnabled:TRUE];
        [processButton setEnabled:TRUE];
        [textProcessedField setEnabled:TRUE];
    }
}
-(IBAction)clearInterface:(id)sender{
    [textToProcessField setStringValue:@""];
    [keyField setStringValue:@""];
    [keyLengthTextField setStringValue:@""];
    [maxRandomValueField setStringValue:@""];
    [textProcessedField setStringValue:@""];
    [self processActionSelectorChange:self];
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
    NSString *encryptedString = [encryptorObject encryptStringToProcessWithKey:keyString];
    NSLog(@"Interface: Encryption Finished With result [%@]", encryptedString);
    [textProcessedField setStringValue:encryptedString];
    [self textEncryptionSequence:self];
}
-(IBAction)decryptText:(id)sender{
    NSLog(@"Interface: Encryption Started");
    NSString *stringToProcess = [textToProcessField stringValue];
    NSString *keyString = [keyField stringValue];
    HSTextEncryptor *encryptorObject = [[HSTextEncryptor alloc] initWithNSString:stringToProcess];
    NSString *decryptedString = [encryptorObject decryptStringToProcessWithKey:keyString];
    NSLog(@"Interface: Decryption Finished With result [%@]", decryptedString);
    [textProcessedField setStringValue:decryptedString];
    [self textEncryptionSequence:self];
}

@end
