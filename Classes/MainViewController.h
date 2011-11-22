//
//  Phrase.h
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "XFSM_Wrap.h"
#import "PhraseViewController.h"

@interface MainViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSMutableArray	*listContent;	// The content filtered as a result of a search.

	// The saved state of the search UI if a memory warning removed the view.
	NSMutableArray	*savedListContent;			// The results of the FST
    NSString		*savedSearchTerm;
    BOOL			searchWasActive;
	
	NSArray			*allAffixes;
	
	PhraseViewController	*phraseView;
	
	XFSM_Wrap		*fstInterface;			// The main fst interface
	XFSM_Wrap		*uncleanFstInterface;
	XFSM_Wrap		*romajiFstInterface;	// Converts hiragana to romaji
	XFSM_Wrap		*hiraganaFstInterface;	// vice-versa
}

@property (nonatomic, retain) NSMutableArray *listContent;

@property (nonatomic, retain) NSMutableArray *savedListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic,retain) PhraseViewController *phraseView;
@property (nonatomic,retain) NSArray *allAffixes;

@property (nonatomic,retain) XFSM_Wrap *fstInterface;
@property (nonatomic,retain) XFSM_Wrap *uncleanFstInterface;
@property (nonatomic,retain) XFSM_Wrap *romajiFstInterface;
@property (nonatomic,retain) XFSM_Wrap *hiraganaFstInterface;

@end
