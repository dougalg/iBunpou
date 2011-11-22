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

@synthesize fstResult, rawAffixes, dictForm, pos, dispPos, affixes;

+ (id)initWithFSTResult:(NSString *)df
{
	Phrase *newPhrase = [[[self alloc] init] autorelease];
	NSArray *bits = [df componentsSeparatedByString:@"&"];
	if ([bits count] >= 2) {
		newPhrase.fstResult = df;
		newPhrase.pos = [bits objectAtIndex:0];
		newPhrase.dispPos = [self getDispPos:newPhrase.pos];
		NSArray *bits2 = [[bits objectAtIndex:1] componentsSeparatedByString:@"+"];
		newPhrase.dictForm = [bits2 objectAtIndex:0];
		
		NSRange bits2Range;
		bits2Range.location = 1;
		bits2Range.length = [bits2 count] - 1;
		newPhrase.rawAffixes = [bits2 subarrayWithRange:bits2Range];
	}
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
- (void)setAffixesWithUncleanResults:(NSArray *)uncleanResults usingAffixArray:(NSArray *) allAffixes;
{
	NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *uncleanTempArray = [[[NSMutableArray alloc] init] autorelease];
	// Split each unclean affix string into an array of separate results that we can access by index ;ater
	for (id uncleanAffixStr in uncleanResults) {
		NSArray *uncleanAffixes = [uncleanAffixStr componentsSeparatedByString:@"+"];
		// The first result should be ignored as it is just the root
		// Also the counts are not off by exactly 1, we will report an error
		if ([uncleanAffixes count] - 1 == [self.rawAffixes count]) {
			[uncleanTempArray addObject:uncleanAffixes];
		}
	}
	// We will loop over each affix in the rawAffix array and check how many syntactic forms (sForms) we need using the unclean affix array
	[self.rawAffixes enumerateObjectsUsingBlock:^(id affix, NSUInteger idx, BOOL *stop) {
		NSMutableArray *sForms = [[[NSMutableArray alloc] init] autorelease];
		for (id uncleanAffixArr in uncleanTempArray) {
			// Remember that there is the additional root form, so we use +1 (magic numbers...)
			NSMutableString *uncleanTemp = [NSMutableString stringWithString:[uncleanAffixArr objectAtIndex:idx+1]];
			// Add the + to beggining of str
			[uncleanTemp insertString:@"+" atIndex:0];
			// Formatting, replace ! with space
			uncleanTemp = [uncleanTemp stringByReplacingOccurrencesOfString:@"!" withString:@" "];
			// We don't need to show the same suffix twice
			if (![sForms containsObject:uncleanTemp]) {
				[sForms addObject:uncleanTemp];
			}
		}
		Affix *newAffix = [Affix initWithFstCode:affix andSForms:sForms andAffixArray:allAffixes andPOS:self.pos];
		[tempArray addObject:newAffix];
	}];
	self.affixes = tempArray;
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
