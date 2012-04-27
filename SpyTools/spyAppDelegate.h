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
    NSString    *stringToProcess;
}
/*Global*/
@property (weak) IBOutlet NSTabView *glTabView;
/*Text Encryption*/
@property (weak) IBOutlet NSSegmentedControl *teOperationSelector;
@property (weak) IBOutlet NSTextField *teInputTextField;
@property (weak) IBOutlet NSSegmentedControl *teKeyTypeSelector;
@property (weak) IBOutlet NSSegmentedControl *teKeyLengthSelector;
@property (weak) IBOutlet NSButton *teGenerateKeyButton;
@property (weak) IBOutlet NSButton *teProcessButton;
@property (weak) IBOutlet NSTextField *teOutputText;
@property (weak) IBOutlet NSTextField *teInformationLabel;
@property (weak) IBOutlet NSTextField *teInputTextLabel;
@property (weak) IBOutlet NSTextField *teKeyFieldLabel;
@property (weak) IBOutlet NSTextField *teOutputTextLabel;
@property (weak) IBOutlet NSBox *teRandomKeyBox;
@property (weak) IBOutlet NSTextField *teKeyTextField;
@property (weak) IBOutlet NSTextField *teKeyTypeLabel;
@property (weak) IBOutlet NSTextField *teKeyLengthLabel;
/*Text In Image Encryption*/
@property (weak) IBOutlet NSSegmentedControl *tiOperationSelector;
@property (weak) IBOutlet NSSegmentedControl *tiKeyTypeSelector;
@property (weak) IBOutlet NSTextField *tiInputTextField;
@property (weak) IBOutlet NSImageView *tiInputImageWell;
@property (weak) IBOutlet NSSegmentedControl *tiKeyLengthSelector;
@property (weak) IBOutlet NSTextField *tiKeyTextField;
@property (weak) IBOutlet NSButton *tiGenerateKeyButton;
@property (weak) IBOutlet NSButton *tiProcessButton;
@property (weak) IBOutlet NSTextField *tiOutputTextField;
@property (weak) IBOutlet NSTextField *tiInputTextLabel;
@property (weak) IBOutlet NSTextField *tiOutputTextLabel;
@property (weak) IBOutlet NSProgressIndicator *tiProgressIndicator;
@property (weak) IBOutlet NSSegmentedControl *tiOutputFormatSelector;
@property (weak) IBOutlet NSTextField *tiKeyTextLabel;
@property (weak) IBOutlet NSTextField *tiImageInputLabel;
@property (weak) IBOutlet NSTextField *tiImageOutputLabel;
@property (weak) IBOutlet NSImageView *tiOutputImageWell;
/*Image In Image Encryption*/
@property (weak) IBOutlet NSSegmentedControl *iiOperationSelector;
@property (weak) IBOutlet NSImageView *iiInputImageWell;
@property (weak) IBOutlet NSImageView *iiInputImageToBeEncryptedWell;

@property (weak) IBOutlet NSTextField *iiInputImageLabel;
@property (weak) IBOutlet NSTextField *iiInputToBeEncryptedLabel;
@property (weak) IBOutlet NSSegmentedControl *iiOutputFormatSelector;
@property (weak) IBOutlet NSImageView *iiOutputImageWell;
@property (weak) IBOutlet NSTextField *iiOutputImageLabel;
@property (weak) IBOutlet NSButton *iiProcessButton;



/*Interface Methods-----------------------*/
-(IBAction)operationSelectorChange:(id)sender;
-(IBAction)keyTypeSelectorChange:(id)sender;
-(IBAction)tiOperationSelectorChange:(id)sender;
-(IBAction)tiKeyTypeSelectorChange:(id)sender;
/*Text Encryption*/
-(IBAction)generateRandomKey:(id)sender;
-(IBAction)generateRandomPassphrase:(id)sender;
-(IBAction)generateKeySelector:(id)sender;
-(IBAction)oneTimePadEncryptText:(id)sender;
-(IBAction)onetimePadDecryptText:(id)sender;
-(IBAction)oneTimePadSelector:(id)sender;
/*Text in Image Encryption*/
-(IBAction)tiGenerateRandomKey:(id)sender;
-(IBAction)tiGenerateRandomPassphrase:(id)sender;
-(IBAction)tiGenerateKeySelector:(id)sender;
-(IBAction)tiOneTimePadEncryptText:(id)sender;
-(IBAction)tiOnetimePadDecryptText:(id)sender;
-(IBAction)tiOneTimePadSelector:(id)sender;
-(IBAction)tiEncryptSteganography:(id)sender;
-(IBAction)tiDecryptSteganography:(id)sender;
-(IBAction)tiTextSteganographySelector:(id)sender;
/*Image in Image Encryption*/
-(IBAction)iiEncryptImage:(id)sender;
-(IBAction)iiDecryptImage:(id)sender;
-(IBAction)iiImageSteganographySelector:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@end
