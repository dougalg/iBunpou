//
//  XFSM_Wrap.h
//  iBunpou
//
//  Created by Dougal Graham on 11-11-19.
//  Copyright 2011 BFITS. All rights reserved.
//
// Obj-C wrapper for XFSMInterface

#import <Foundation/Foundation.h>

struct XFSMWrapOpaque;

@interface XFSM_Wrap : NSObject {
	struct XFSMWrapOpaque *_cpp;
}

- (id)initializeWithFSTName:(NSString *)fstName;
- (NSArray *)getApplyResultsUp:(NSString *)queryStr;
- (NSArray *)getApplyResultsDown:(NSString *)queryStr;

@end
