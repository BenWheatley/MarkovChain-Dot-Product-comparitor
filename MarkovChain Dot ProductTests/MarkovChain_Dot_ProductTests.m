//
//  MarkovChain_Dot_ProductTests.m
//  MarkovChain Dot ProductTests
//
//  Created by Ben Wheatley on 22/01/2024.
//

#import <XCTest/XCTest.h>
#import "MarkovModel.h"

// String constants for testing, scoped to this file
static NSString *const commonTestInputString = @"मुझे खुशी है कि आपसे मिलकर। आपका सवाल सुनकर मैं आपकी सहायता करने के लिए यहाँ हूँ। हिंदी भाषा एक सुंदर और समृद्ध भाषा है, जिसमें विभिन्न सांस्कृतिक और ऐतिहासिक परंपराएं समाहित हैं। यह भाषा दक्षिण एशिया के कई हिस्सों में बोली जाती है और इसकी विशेषता है कि इसमें व्यक्ति और समाज के बीच संवाद को महत्वपूर्ण माना जाता है। कृपया आपके किसी विशेष विषय या प्रश्न को साझा करें ताकि मैं आपकी और अधिक मदद कर सकूँ।";

static NSString *const commonTestInputString2 = @"Linear B is an ancient script that was used primarily for the recording of the Mycenaean Greek language during the Late Bronze Age. The script was deciphered by the architect and classicist Michael Ventris in 1952. Linear B inscriptions have been found on clay tablets and other objects at various archaeological sites, notably in the palace of Knossos on the island of Crete and Pylos on the Greek mainland. These inscriptions provide valuable insights into aspects of Mycenaean civilization, including administration, economy, and religious practices. While Linear B is not a spoken language, it played a crucial role in documenting the linguistic and cultural heritage of the Mycenaean Greeks.";

@interface MarkovChain_Dot_ProductTests : XCTestCase

@end

@implementation MarkovChain_Dot_ProductTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(ArrayOfInputOutputPairs *) createInputOutputPairs_commonTestInputString {
	return [MarkovModel createListOfAllTokenTransitionPairsFrom: commonTestInputString
														   with: wordLike];
}

-(ArrayOfInputOutputPairs *) createInputOutputPairs_commonTestInputString2 {
	return [MarkovModel createListOfAllTokenTransitionPairsFrom: commonTestInputString2
														   with: wordLike];
}

-(MarkovModel *) createModel_with_wordLike_using_commonTestInputString {
	return [[MarkovModel alloc] initWith:[self createInputOutputPairs_commonTestInputString]];
}

-(MarkovModel *) createModel_with_wordLike_using_commonTestInputString2 {
	return [[MarkovModel alloc] initWith:[self createInputOutputPairs_commonTestInputString2]];
}

- (void)testCreateListOfAllTokenTransitionPairs_with_wordLike {
	ArrayOfInputOutputPairs *result =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: @"five words has four transitions"
														with: wordLike];
	
	XCTAssertEqual(result.count, 4);
}

- (void)testCreateListOfAllTokenTransitionPairs_with_characterLike {
	NSString *someTestString = @"something";
	ArrayOfInputOutputPairs *result =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: someTestString
														with: characterLike];
	
	XCTAssertEqual(result.count, someTestString.length-1);
}

- (void)testCreateListOfAllTokenTransitionPairs_with_characterLike_repeatedCharacters {
	NSString *someTestString = @"aaaaaa";
	ArrayOfInputOutputPairs *result =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: someTestString
														with: characterLike];
	
	XCTAssertEqual(result.count, someTestString.length-1);
}

- (void)testCreateListOfAllTokenTransitionPairs_with_characterLike_using_commonTestInputString {
	ArrayOfInputOutputPairs *result = [self createInputOutputPairs_commonTestInputString];
	
	XCTAssertEqual(result.count, [commonTestInputString componentsSeparatedByString:@" "].count-1);
}

- (void)testInitialization {
	// Test case for initWith:
	
	MarkovModel *model = [self createModel_with_wordLike_using_commonTestInputString];
	
	XCTAssertNotNil(model);
	XCTAssertNotNil(model.markovChain);
}

- (void)testCosineMaximalSimilarity {
	MarkovModel *model = [self createModel_with_wordLike_using_commonTestInputString];
	
	XCTAssertEqual([model cosineSimilarity:model], 1); // Cosine similarity with itself should always be 1
}

- (void)testCosineMaximalDifference {
	MarkovModel *model1 = [self createModel_with_wordLike_using_commonTestInputString];
	MarkovModel *model2 = [self createModel_with_wordLike_using_commonTestInputString2];
	
	XCTAssertEqual([model1 cosineSimilarity:model2], 0); // Cosine similarity with should be 0 when there's nothing in common
}

- (void)testCosine_shortStrings_with_maximalDifference {
	NSString *someTestString1 = @"aa";
	NSString *someTestString2 = @"ab";
	ArrayOfInputOutputPairs *pairs1 =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: someTestString1
														with: characterLike];
	ArrayOfInputOutputPairs *pairs2 =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: someTestString2
														with: characterLike];
	MarkovModel *model1 = [[MarkovModel alloc] initWith:pairs1];
	MarkovModel *model2 = [[MarkovModel alloc] initWith:pairs2];
	
	float cosineSimilarity = [model1 cosineSimilarity:model2];
	XCTAssertFalse(isnan(cosineSimilarity));
	XCTAssertEqual([model1 cosineSimilarity:model2], 0);
}

- (void)testCosine_with_longStrings_with_minimalDifference {
	NSString *someTestString1 = @"aaaaaaaaaaaaaa";
	NSString *someTestString2 = @"aaaaaaaaaaaaab";
	ArrayOfInputOutputPairs *pairs1 =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: someTestString1
														with: characterLike];
	ArrayOfInputOutputPairs *pairs2 =
		[MarkovModel createListOfAllTokenTransitionPairsFrom: someTestString2
														with: characterLike];
	MarkovModel *model1 = [[MarkovModel alloc] initWith:pairs1];
	MarkovModel *model2 = [[MarkovModel alloc] initWith:pairs2];
	
	// I could calculate my expectations directly, but that comes with a high risk of having made the same fundamental error in both cases
	float cosineSimilarity = [model1 cosineSimilarity:model2];
	XCTAssertFalse(isnan(cosineSimilarity));
	XCTAssertLessThan(cosineSimilarity, 1);
	XCTAssertGreaterThan(cosineSimilarity, 0.75);
}

@end
