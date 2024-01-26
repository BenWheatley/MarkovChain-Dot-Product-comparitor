//
//  MarkovModel.m
//  MarkovChain Dot Product
//
//  Created by Ben Wheatley on 22/01/2024.
//

#import "MarkovModel.h"

@implementation MarkovModel

+ (ArrayOfInputOutputPairs *)createListOfAllTokenTransitionPairsFrom:(NSString*)string with:(Tokenizer)tokenizer {
	switch (tokenizer) {
		case wordLike:
			return [self wordLikeFrom: string];
		case characterLike:
			return [MarkovModel charNchar1From: string withWindowSize: 1];
		case char3char1:
			return [MarkovModel charNchar1From: string withWindowSize: 3];
	}
}

+ (ArrayOfInputOutputPairs *)wordLikeFrom:(NSString*)string {
	NSArray *wordsArray = [string componentsSeparatedByString:@" "];
	ArrayOfInputOutputPairs *result = [NSMutableArray new];
	for (int index=0; index<(wordsArray.count-1); index++) {
		InputOutputPair *item = @{wordsArray[index]: wordsArray[index+1]};
		[result addObject: item];
	}
	return result;
}

+ (ArrayOfInputOutputPairs *)charNchar1From:(NSString*)string withWindowSize:(unsigned int)windowSize {
	NSMutableArray *result = [NSMutableArray new];
	for (int index=0; index<(string.length-windowSize); index++) {
		NSString *state = [string substringWithRange:(NSMakeRange(index, windowSize))];
		NSString *target = [string substringWithRange:(NSMakeRange(index+windowSize, 1))];
		InputOutputPair *item = @{state: target};
		[result addObject:item];
	}
	return result;
}

-(instancetype)initWith:(ArrayOfInputOutputPairs*)inputOutputPairs {
	if (!(self = [super init])) { return nil; }
	
	NSMutableDictionary *rawChain = [NSMutableDictionary dictionary]; // not normalized, used to associate the data correctly
			
	// Iterate through input-output pairs
	for (InputOutputPair *pair in inputOutputPairs) {
		NSString *state = pair.allKeys.firstObject;
		NSString *target = pair.allValues.firstObject;
		
		// Create a new entry for the state if it doesn't exist
		if (!rawChain[state]) { rawChain[state] = [NSMutableDictionary dictionary]; }
		
		// Increment the count for the specific target state
		NSNumber *currentCount = rawChain[state][target] ?: @(0);
		rawChain[state][target] = @(currentCount.intValue + 1);
	}
	
	// Now normalize the values in rawChain to produce markovChain
	for (NSString *key in rawChain.allKeys) {
		NSMutableDictionary<NSString *, NSNumber *> *stateTransitions = rawChain[key];
		
		// Calculate the total count for the current state
		NSInteger totalCount = [[stateTransitions.allValues valueForKeyPath:@"@sum.self"] integerValue]; // Seems to be the idiomatic way to reduce in ObjC, though it is new-to-me
		
		// Normalize the counts to probabilities (0-1)
		for (NSString *innerKey in stateTransitions.allKeys) {
			NSNumber *count = stateTransitions[innerKey];
			double probability = count.doubleValue / totalCount;
			stateTransitions[innerKey] = @(probability);
		}
	}
	
	self.markovChain = rawChain;
	
	return self;
}

-(float) cosineSimilarity:(MarkovModel*)otherModel {
	// The chain is represented as: {state: {target: probability, …}}, where sum of all probability for any given state is normalized to 1
	// Where a token is present in one chain but not the other, this should be treated as maximally orthogonal
	// Where a token is not listed in the target dictionary, this should be treated as p=0
	// object is found in self.markovChain
	
	// Every key in both
	NSSet<NSString*> *unionOfKeys = [[NSSet setWithArray:self.markovChain.allKeys]
									 setByAddingObjectsFromArray:otherModel.markovChain.allKeys];
	
	float dotProductRollingSum = 0;
	float magnitudeSquaredSelfRollingSum = 0;
	float magnitudeSquaredOtherRollingSum = 0;
	for (NSString *key in unionOfKeys) {
		if (self.markovChain[key] == nil) {
			// maximum orthogonality with regards to otherModel.markovChain.allKeys
			magnitudeSquaredSelfRollingSum += 0; // Square of 0
			magnitudeSquaredOtherRollingSum += 1; // Square of 1
			dotProductRollingSum += 0; // Dot product is 0 for orthogonal vectors; no-op, written explicitly for clarity
			
		} else if (otherModel.markovChain[key] == nil) {
			// maximum orthogonality with regards to self.markovChain.allKeys
			magnitudeSquaredSelfRollingSum += 1; // Square of 1
			magnitudeSquaredOtherRollingSum += 0; // Square of 0
			dotProductRollingSum += 0; // Dot product is 0 for orthogonal vectors; no-op, written explicitly for clarity
			
		} else {
			// to be in this branch the key has to be in both Markov chains
			// normal dot product
			NSDictionary<NSString *, NSNumber *> *selfTransitions = self.markovChain[key];
			NSDictionary<NSString *, NSNumber *> *otherTransitions = otherModel.markovChain[key];
			
			NSSet<NSString*> *unionOfAllTargetKeys =
				[[NSSet setWithArray: selfTransitions.allKeys]
				 setByAddingObjectsFromArray: otherTransitions.allKeys];
			for (NSString *targetState in unionOfAllTargetKeys) {
				float selfProbability = [selfTransitions[targetState] floatValue] ?: 0;
				float otherProbability = [otherTransitions[targetState] floatValue] ?: 0;
				
				dotProductRollingSum += selfProbability * otherProbability;
				magnitudeSquaredSelfRollingSum += selfProbability * selfProbability;
				magnitudeSquaredOtherRollingSum += otherProbability * otherProbability;
			}
		}
	}
	float magnitudeSelf = sqrt(magnitudeSquaredSelfRollingSum);
	float magnitudeOther = sqrt(magnitudeSquaredOtherRollingSum);
	
	return dotProductRollingSum / (magnitudeSelf * magnitudeOther);
}

@end
