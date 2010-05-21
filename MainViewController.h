//
//  Phrase.h
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "XFSMInterface.h"
#import "PhraseViewController.h"

@interface MainViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSMutableArray	*listContent;	// The content filtered as a result of a search.
	XFSMInterface	fstInterface;	// The object for working with the FST
	XFSMInterface	hiraganaFstInterface;	// The object for working with the FST
	
	// The saved state of the search UI if a memory warning removed the view.
	NSMutableArray	*savedListContent;			// The results of the FST
    NSString		*savedSearchTerm;
    BOOL			searchWasActive;
	
	PhraseViewController	*phraseView;
}

@property (nonatomic, retain) NSMutableArray *listContent;

@property (nonatomic, retain) NSMutableArray *savedListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic) XFSMInterface fstInterface;
@property (nonatomic) XFSMInterface hiraganaFstInterface;

@property (nonatomic,retain) PhraseViewController *phraseView;

@end
