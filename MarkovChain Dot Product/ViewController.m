//
//  ViewController.m
//  MarkovChain Dot Product
//
//  Created by Ben Wheatley on 22/01/2024.
//

#import "ViewController.h"
#import "MarkovModel.h"

@implementation ViewController

@synthesize tokenizer;
@synthesize leftDocument;
@synthesize rightDocument;
@synthesize result;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
	// Update the view, if already loaded.
}

- (void) recalculateSimilarity {
	Tokenizer selectedTokenizer = tokenizer.indexOfSelectedItem;
	
	MarkovModel *leftMarkov =
		[[MarkovModel alloc]
		 initWith: [MarkovModel createListOfAllTokenTransitionPairsFrom: leftDocument.stringValue
																   with: selectedTokenizer]];
	MarkovModel *rightMarkov =
		[[MarkovModel alloc]
		 initWith: [MarkovModel createListOfAllTokenTransitionPairsFrom: rightDocument.stringValue
																   with: selectedTokenizer]];
	
	float cosineSimilarity = [leftMarkov cosineSimilarity: rightMarkov];
	float angle = (180.0 / M_PI) * acos(cosineSimilarity);
	NSString *cosineSimilarityString = isnan(angle) ? @"-" : [NSString stringWithFormat:@"%.2f°", angle];
	[result setStringValue:cosineSimilarityString];
}

# pragma mark - delegates and actions

-(IBAction)tokenizerChanged:(NSPopUpButton*)sender {
	[self recalculateSimilarity];
}

- (void)controlTextDidChange:(NSNotification *)notification {
	[self recalculateSimilarity];
}

@end
