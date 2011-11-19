//
//  Affix.mm
//  iBunpou
//
//  Created by Dougal Graham on 11-11-05.
//  Copyright 2011 BFITS. All rights reserved.
//

#import "Affix.h"

@implementation Affix

@synthesize fstCode, sForms, hFormShort, hFormLong;

+ (id)initWithFstCode:(NSString *)anFstCode andAffixArray:(NSArray *)allAffixes andPOS:(NSString *)POS
{
	Affix *newAffix = [[[self alloc] init] autorelease];
	
	NSDictionary *relatedAffix = [self findRelatedAffixFromFSTCode:anFstCode andAffixArray:allAffixes andPOS:POS];
	
	newAffix.fstCode = anFstCode;
	newAffix.sForms = [relatedAffix objectForKey:@"sForms"];
	newAffix.hFormShort = [relatedAffix objectForKey:@"hFormShort"];	
	return newAffix;
}

+ (NSDictionary*)findRelatedAffixFromFSTCode:(NSString *)anFstCode andAffixArray:(NSArray *)allAffixes andPOS:(NSString *)POS
{
	for (id permAffix in allAffixes) {
		if ([anFstCode isEqualToString:[permAffix objectForKey: @"fstCode"]]) {
			// Some special cases require checking the category
			if ([POS isEqualToString:[permAffix objectForKey: @"category"]]) {
				return permAffix;
			}
		}
	}
	return [[[NSDictionary alloc] init] autorelease];
}

- (void)dealloc
{
	[fstCode release];
	[sForms release];
	[hFormShort release];
	[hFormLong release];
	[super dealloc];
}

@end
