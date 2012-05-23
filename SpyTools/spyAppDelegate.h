//
//  spyAppDelegate.h
//  SpyTools
//
//  Created by Chip on 4/12/12.
//  Copyright (c) 2012 __Héctor Sánchez__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HSTextEncryptor.h"
#import "HSImageEncryptor.h"
#import "HSKeyLibrary.h"
#import "HSCryptoFunctions.h"

@interface spyAppDelegate : NSObject <NSApplicationDelegate>{
    float       compressionFactor;
    BOOL        tiTextFits;
    NSString    *stringToProcess;
}
/*Global*/
@property float compressionFactor;
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
@property (weak) IBOutlet NSTextField *tiAnalyzeLabel;
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
@property (weak) IBOutlet NSProgressIndicator *iiProgressIndicator;
@property (weak) IBOutlet NSTextField *iiAnalyzeLabel;
@property (weak) IBOutlet NSButton *iiGeneratePassphraseButton;
@property (weak) IBOutlet NSTextField *iiPassphraseTextField;
/*File In Image Encryption*/
@property (weak) IBOutlet NSSegmentedControl *fiOperationSelector;
@property (weak) IBOutlet NSImageView *fiInputImageWell;
@property (weak) IBOutlet NSTextField *fiFileToBeEncryptedField;
@property (weak) IBOutlet NSTextField *fiInputImageLabel;
@property (weak) IBOutlet NSTextField *fiFileToBeEncryptedLabel;
@property (weak) IBOutlet NSSegmentedControl *fiOutputFormatSelector;
@property (weak) IBOutlet NSImageView *fiOutputImageWell;
@property (weak) IBOutlet NSTextField *fiOutputImageLabel;
@property (weak) IBOutlet NSProgressIndicator *fiProgressIndicator;
@property (weak) IBOutlet NSTextField *fiAnalyzeLabel;
@property (weak) IBOutlet NSButton *fiGeneratePassphraseButton;
@property (weak) IBOutlet NSTextField *fiPassphraseTextField;
@property (weak) IBOutlet NSButton *fiProcessButton;


/*Interface Methods-----------------------*/
-(IBAction)operationSelectorChange:(id)sender;
-(IBAction)keyTypeSelectorChange:(id)sender;
-(IBAction)tiOperationSelectorChange:(id)sender;
-(IBAction)tiKeyTypeSelectorChange:(id)sender;
-(IBAction)iiOperationSelectorChange:(id)sender;
-(IBAction)fiOperationSelectorChange:(id)sender;
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
-(IBAction)tiSizeCheck:(id)sender;
/*Image in Image Encryption*/
-(IBAction)iiEncryptImage:(id)sender;
-(IBAction)iiDecryptImage:(id)sender;
-(IBAction)iiImageSteganographySelector:(id)sender;
-(IBAction)iiSizeCheck:(id)sender;
-(IBAction)iiGenerateRandomPassphrase:(id)sender;
/*File in Image Encryption*/
-(IBAction)fiEncryptImage:(id)sender;
-(IBAction)fiDecryptImage:(id)sender;
-(IBAction)fiImageSteganographySelector:(id)sender;
-(IBAction)fiSizeCheck:(id)sender;
-(IBAction)fiGenerateRandomPassphrase:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@end
