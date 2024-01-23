//
//  ViewController.h
//  MarkovChain Dot Product
//
//  Created by Ben Wheatley on 22/01/2024.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSPopUpButton *tokenizer;

@property (nonatomic, weak) IBOutlet NSTextField *leftDocument;
@property (nonatomic, weak) IBOutlet NSTextField *rightDocument;

@property (nonatomic, weak) IBOutlet NSTextField *result;

-(IBAction)tokenizerChanged:(NSPopUpButton*)sender;

@end

