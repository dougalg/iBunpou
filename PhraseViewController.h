//
//  PhraseViewController.h
//  Bunpou
//
//  Created by Dougal Graham on 10-05-20.
//  Copyright 2010 JET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phrase.h"


@interface PhraseViewController : UIViewController {
	IBOutlet UILabel		*pos;
	NSMutableArray			*affixes;
	IBOutlet UILabel		*enteredForm;
	IBOutlet UILabel		*dictForm;
	Phrase					*phrase;
}

@property(nonatomic, retain) IBOutlet UILabel		*pos;
@property(nonatomic, retain) IBOutlet UILabel		*enteredForm;
@property(nonatomic, retain) IBOutlet UILabel		*dictForm;
@property(nonatomic, retain) NSMutableArray			*affixes;
@property(nonatomic, retain) Phrase					*phrase;

@end
