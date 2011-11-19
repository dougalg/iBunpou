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

- (NSString*)getApplyResultsUp:(NSString *)queryStr {
	// Pass temp char to self.cpp
	char *results = self.cpp->interface.getApplyResultsUp([queryStr UTF8String]);
	// Convert result to NSString
	if (results) {
		return [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
	}
	// Return nsresults
	return queryStr;
}

- (NSString*)getApplyResultsDown:(NSString *)queryStr {
	// Pass temp char to self.cpp
	char *results = self.cpp->interface.getApplyResultsDown([queryStr UTF8String]);
	// Convert result to NSString
	if (results) {
		return [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
	}
	// Return nsresults
	return queryStr;
}

@end
