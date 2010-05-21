//
//  Phrase.m
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "Phrase.h"


@implementation Phrase

@synthesize dictForm, pos, affixes;

+ (id)initWithFSTResult:(NSString *)df
{
	Phrase *newPhrase = [[[self alloc] init] autorelease];
	
	NSArray *bits = [df componentsSeparatedByString:@"&"];
	
	newPhrase.pos = [bits objectAtIndex:0];
	
	NSArray *bits2 = [[bits objectAtIndex:1] componentsSeparatedByString:@"+"];
	newPhrase.dictForm = [bits2 objectAtIndex:0];
	//newPhrase.dictForm = df;
	
	NSRange bits2Range;
	bits2Range.location = 1;
	bits2Range.length = [bits2 count] - 1;
	newPhrase.affixes = [bits2 subarrayWithRange:bits2Range];
	
	return newPhrase;
}

- (void)dealloc
{
	[dictForm release];
	[pos release];
	[affixes release];
	[super dealloc];
}

@end
