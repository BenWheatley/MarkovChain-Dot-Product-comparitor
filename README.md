# What?

A Markov chain is a very simple language model: For any given symbol (usually a word), what symbols come next, and with what probabilities?

This generates a Markov model for two documents, then does a dot-product to compare them. As any given symbols might not be in both documents, and two documents that don't share any symbols are obviously orthogonal, this dot product is calculated with the assumption that:

Assuming I've not gotten confused (which is always a possibility, especially for a solo project like this):

<img width="198" alt="Screenshot 2024-01-23 at 14 54 58" src="https://github.com/BenWheatley/MarkovChain-Dot-Product-comparitor/assets/12123132/5037257e-8d43-45b6-9b79-4a11796259a4">

Then divide by the magnitude of each Markov model… (hang on, the transition vectors are normalised already, so the magnitudes should be equal to the number of non-terminal symbols… hmm, perhaps this is why they're so much more dissimilar than I was expecting?)… to get the cosine of the angles between the vectors that the Markov chains represent.

# Why make it at all?

I want to see how good this mechanism is at identifying authorship.

The short answer is: ha ha no

The long answer is: within a language, almost all the documents I tried were in the range of 85-88° from parallel, so at the very least it needs something to alter the dynamic range if I want to get anything resembling a useful insight

# Why is the first version of this ObjC in AppKit?

Someone was interested in interviewing me for a Mac desktop job with ObjC code, and I've not done ObjC for 5 years so I thought "this project I've had on the back burner for ages, I'll do that in ObjC and for macOS".

I may redo in JS or something later. But only if I can make a version which is more useful than to falisify my hypothesis about this being useful.
