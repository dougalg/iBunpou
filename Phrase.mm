//
//  Phrase.m
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "Phrase.h"

@implementation Phrase

@synthesize dictForm, pos, dispPos, affixes;

+ (id)initWithFSTResult:(NSString *)df
{
	Phrase *newPhrase = [[[self alloc] init] autorelease];
	
	NSArray *bits = [df componentsSeparatedByString:@"&"];
	
	newPhrase.pos = [bits objectAtIndex:0];
	newPhrase.dispPos = [self getDispPos:newPhrase.pos];
	
	NSArray *bits2 = [[bits objectAtIndex:1] componentsSeparatedByString:@"+"];
	newPhrase.dictForm = [bits2 objectAtIndex:0];
	//newPhrase.dictForm = df;
	
	NSRange bits2Range;
	bits2Range.location = 1;
	bits2Range.length = [bits2 count] - 1;
	newPhrase.affixes = [bits2 subarrayWithRange:bits2Range];
	
	return newPhrase;
}

// This function fetched the human readable Display Part of Speech
+ (NSString*)getDispPos:(NSString *)basePos
{
	NSString *lDispPos = [[NSString alloc] init];
	return lDispPos;
}

- (void)dealloc
{
	[dictForm release];
	[pos release];
	[dispPos release];
	[affixes release];
	[super dealloc];
}

@end
