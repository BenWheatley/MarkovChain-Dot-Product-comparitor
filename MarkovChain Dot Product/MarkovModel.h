//
//  MarkovModel.h
//  MarkovChain Dot Product
//
//  Created by Ben Wheatley on 22/01/2024.
//

#ifndef MarkovModel_h
#define MarkovModel_h

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, Tokenizer) {
	wordLike = 0,
	characterLike = 1,
	char3char1 = 2,
};

typedef NSDictionary<NSString*, NSString*> InputOutputPair;
typedef NSMutableArray<InputOutputPair*> ArrayOfInputOutputPairs;

typedef NSDictionary<NSString*, NSNumber*> MarkovTransitionProbabilities;

#pragma mark - Class

@interface MarkovModel : NSObject

+ (ArrayOfInputOutputPairs *)createListOfAllTokenTransitionPairsFrom:(NSString*)string with:(Tokenizer)tokenizer;

/** The chain is represented as:
 {state: {target: probability, …}}, where sum of all probability for any given state is normalized to 1 */
@property NSDictionary<NSString*, MarkovTransitionProbabilities*> *markovChain;

-(id) initWith:(ArrayOfInputOutputPairs*)inputOutputPairs;
-(float) cosineSimilarity:(MarkovModel*)otherModel;

@end

#endif /* MarkovModel_h */
