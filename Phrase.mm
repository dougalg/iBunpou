//
//  Phrase.m
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "Phrase.h"
#import "Affix.h"

@implementation Phrase

@synthesize dictForm, pos, dispPos, affixes;

+ (id)initWithFSTResult:(NSString *)df andAffixArray:(NSArray *)allAffixes
{
	Phrase *newPhrase = [[[self alloc] init] autorelease];
	NSArray *bits = [df componentsSeparatedByString:@"&"];
	
	newPhrase.pos = [bits objectAtIndex:0];
	newPhrase.dispPos = [self getDispPos:newPhrase.pos];
	
	NSArray *bits2 = [[bits objectAtIndex:1] componentsSeparatedByString:@"+"];
	newPhrase.dictForm = [bits2 objectAtIndex:0];
	
	NSRange bits2Range;
	bits2Range.location = 1;
	bits2Range.length = [bits2 count] - 1;
	NSArray *tempArray2 = [bits2 subarrayWithRange:bits2Range];
	newPhrase.affixes = [self getAffixObjects:tempArray2 usingAffixArray:allAffixes andPOS:newPhrase.pos];
	
	return newPhrase;
}

// This function fetches the human readable Display Part of Speech
+ (NSString*)getDispPos:(NSString *)basePos
{
	NSDictionary *poss = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"na Adjective", @"adj-na",
						  @"i Adjective", @"adj-i",
						  @"taru Adjective", @"adj-t",
						  @"Ichidan verb", @"v1",
						  @"Godan verb", @"v5",
						  @"suru verb", @"vs",
						  @"irregular", @"v",
						  nil];
	
	return [poss objectForKey:basePos];
}

// The function converts an array of affixes into an array of affix objects
+ (NSArray*)getAffixObjects:(NSArray *)affixTextArray usingAffixArray:(NSArray *)allAffixes andPOS:(NSString *) POS
{
	NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
	for (id affix in affixTextArray) {
		[tempArray addObject:[Affix initWithFstCode:affix andAffixArray:allAffixes andPOS:POS]];
	}
	return tempArray;
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
