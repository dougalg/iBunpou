//
//  Phrase.h
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

@interface Phrase : NSObject {
	NSString *dictForm;		// The dictionary form of the word
	NSString *pos;			// The part of speech for the word encoded from the FST, eg. V, N, Adj-i, etc...
	NSString *dispPos;		// The part of speech in human readable form
	NSArray *affixes;		// An array of all affixes for the form
}

@property (nonatomic, copy) NSString *dictForm;
@property (nonatomic, copy) NSString *pos;
@property (nonatomic, copy) NSString *dispPos;
@property (nonatomic, copy) NSArray *affixes;

+ (id)initWithFSTResult:(NSString *)df;

@end
