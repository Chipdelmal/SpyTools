//
//  spyAppDelegate.h
//  SpyTools
//
//  Created by Chip on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HSTextEncryptor.h"
#import "HSImageEncryptor.h"
#import "HSKeyLibrary.h"

@interface spyAppDelegate : NSObject <NSApplicationDelegate>{
    BOOL        stTextFits;
    /*Global*/
    IBOutlet    NSSegmentedControl  *processActionSelector;
    IBOutlet    NSTextField         *informationLabel;
    IBOutlet    NSTabView           *tabView;
    IBOutlet    NSButton            *startOverButton;
    /*Text Encryption*/
    IBOutlet    NSBox               *keyGenerationBox;
    IBOutlet    NSTextField         *textToProcessField;
    IBOutlet    NSTextField         *keyLengthTextField;
    IBOutlet    NSTextField         *maxRandomValueField;
    IBOutlet    NSButton            *generateRandomKeyButton;
    IBOutlet    NSButton            *generateRandomPassphraseButton;
    IBOutlet    NSTextField         *keyField;
    IBOutlet    NSButton            *processButton;
    IBOutlet    NSTextField         *textProcessedField;
    IBOutlet    NSButton            *sendToSteganographyButton;
    IBOutlet    NSTabView           *keyTypeTabView;
    /*Text in Image*/
    IBOutlet    NSImageView         *stInputImageWell;
    IBOutlet    NSTextField         *stTextToProcessField;
    IBOutlet    NSTextField         *stTextProcessedField;
    IBOutlet    NSSegmentedControl  *stImageFormatSelector;
    IBOutlet    NSTextField         *stAnalyzeLabel;
    IBOutlet    NSProgressIndicator *stProgressIndicator;
    IBOutlet    NSButton            *stProcessButton;
    IBOutlet    NSButton            *stSendToTextButton;
}
/*Global*/
-(IBAction)processActionSelectorChange:(id)sender;
-(IBAction)textEncryptionSequence:(id)sender;
-(IBAction)textDecryptionSequence:(id)sender;
-(IBAction)clearInterface:(id)sender;
-(IBAction)textImageEncryptionSequence:(id)sender;
-(IBAction)textImageDecryptionSequence:(id)sender;
/*Text Encryption*/
-(IBAction)generateRandomPassphrase:(id)sender;
-(IBAction)generateRandomKey:(id)sender;
-(IBAction)autoGenerateRandomKeyParameters:(id)sender;
-(IBAction)processText:(id)sender;
-(IBAction)encryptText:(id)sender;
-(IBAction)decryptText:(id)sender;
-(IBAction)sendResultToImage:(id)sender;
/*Text in Image Encryption*/
-(IBAction)analyzeSpace:(id)sender;
-(IBAction)encryptTextImage:(id)sender;
-(IBAction)decryptText:(id)sender;
-(IBAction)processTextImage:(id)sender;
-(IBAction)sendResultToText:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@end
