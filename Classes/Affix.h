//
//  Affix.h
//  iBunpou
//
//  Created by Dougal Graham on 11-11-05.
//  Copyright 2011 BFITS. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Affix : NSObject {
	NSString *fstCode;		// The code displayed by the FST, for internal use only?
	NSArray *sForms;		// The syntactic form of the affix, EG, +ta(i), etc.
							// for display in the affixes list
	NSString *hFormShort;	// The short human readable form of the affix also
							// for display in the affixes list
	NSString *hFormLong;	// The short human readable form of the affix also
							// for display in detail pane
	//NSString *url;			// URL linking to detailed explanation of the syntax?
}

@property (nonatomic, copy) NSString *fstCode;
@property (nonatomic, copy) NSArray *sForms;
@property (nonatomic, copy) NSString *hFormShort;
@property (nonatomic, copy) NSString *hFormLong;

+ (id)initWithFstCode:(NSString *)anFstCode andSForms:(NSArray *)sFormsIn andAffixArray:(NSArray *)allAffixes andPOS:(NSString *)POS;
+ (NSDictionary*)findRelatedAffixFromFSTCode:(NSString *)anFstCode andAffixArray:(NSArray *)allAffixes andPOS:(NSString *)POS;

@end