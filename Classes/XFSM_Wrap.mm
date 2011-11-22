//
//  XFSM_Wrap.m
//  iBunpou
//
//  Created by Dougal Graham on 11-11-19.
//  Copyright 2011 BFITS. All rights reserved.
//

#import "XFSM_Wrap.h"
#import "XFSMInterface.h"

@interface XFSM_Wrap ()
@property (nonatomic, readwrite, assign) XFSMWrapOpaque *cpp;
@end

@implementation XFSM_Wrap
@synthesize cpp = _cpp;

struct XFSMWrapOpaque
{
public:
	XFSMWrapOpaque() : interface() {};
	XFSM::XFSMInterface interface;
};

- (id)initializeWithFSTName:(NSString *)fstName {
	self = [super init];
	if (self != nil) {
		self.cpp = new XFSMWrapOpaque();
	}
	
	NSString *path = [[NSBundle mainBundle] pathForResource:fstName ofType: @"fst"];

	self.cpp->interface.initializeWithFSTName([path UTF8String]);
	
	return self;
}

- (NSArray*)getApplyResultsUp:(NSString *)queryStr {
	// Pass temp char to self.cpp
	char *results = self.cpp->interface.getApplyResultsUp([queryStr UTF8String]);
	// Convert result to NSArray
	if (results) {
		NSString *resultsStr = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
		NSString *resultsStr2 = [resultsStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSArray *resultsArray = [resultsStr2 componentsSeparatedByString:@"\n"];
		return resultsArray;
	}
	// Return queryStr if result
	NSArray *oops = [[[NSArray alloc] initWithObjects:queryStr,nil] autorelease];
	return oops;
}

- (NSArray*)getApplyResultsDown:(NSString *)queryStr {
	// Pass temp char to self.cpp
	char *results = self.cpp->interface.getApplyResultsDown([queryStr UTF8String]);
	// Convert result to NSArray
	if (results) {
		NSString *resultsStr = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
		NSString *resultsStr2 = [resultsStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSArray *resultsArray = [resultsStr2 componentsSeparatedByString:@"\n"];
		return resultsArray;
	}
	// Return queryStr if result
	NSArray *oops = [[[NSArray alloc] initWithObjects:queryStr,nil] autorelease];
	return oops;
}

@end
