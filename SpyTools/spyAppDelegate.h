//
//  spyAppDelegate.h
//  SpyTools
//
//  Created by Chip on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HSTextEncryptor.h"

@interface spyAppDelegate : NSObject <NSApplicationDelegate>{
    /*Global*/
    IBOutlet    NSSegmentedControl  *processActionSelector;
    IBOutlet    NSTextField         *informationLabel;
    IBOutlet    NSTabView           *tabView;
    /*Text Encryption*/
    IBOutlet    NSBox               *keyGenerationBox;
    IBOutlet    NSTextField         *textToProcessField;
    IBOutlet    NSButton            *autoRandomKeyCheckbox;
    IBOutlet    NSTextField         *keyLengthTextField;
    IBOutlet    NSTextField         *maxRandomValueField;
    IBOutlet    NSButton            *textLengthButton;
    IBOutlet    NSButton            *generateRandomKeyButton;
    IBOutlet    NSTextField         *keyField;
    IBOutlet    NSButton            *processButton;
    IBOutlet    NSTextField         *textProcessedField;
    /*Text in Image*/
}

-(IBAction)processActionSelectorChange:(id)sender;
-(IBAction)textEncryptionSequence:(id)sender;
-(IBAction)textDecryptionSequence:(id)sender;

-(IBAction)processText:(id)sender;

-(IBAction)encryptText:(id)sender;
-(IBAction)decryptText:(id)sender;


@property (assign) IBOutlet NSWindow *window;
@end
