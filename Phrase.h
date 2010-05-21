//
//  Phrase.h
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

@interface Phrase : NSObject {
	NSString *dictForm;
	NSString *pos;
	NSArray *affixes;
}

@property (nonatomic, copy) NSString *dictForm;
@property (nonatomic, copy) NSString *pos;
@property (nonatomic, copy) NSArray *affixes;

+ (id)initWithFSTResult:(NSString *)df;

@end
