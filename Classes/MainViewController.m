//
//  Phrase.h
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "MainViewController.h"
#import "Phrase.h"

@implementation MainViewController

@synthesize listContent, savedListContent, savedSearchTerm, searchWasActive, phraseView, allAffixes, fstInterface, uncleanFstInterface, hiraganaFstInterface, romajiFstInterface;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"Search";

	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        self.searchDisplayController.searchBar.text = savedSearchTerm;
		self.listContent = self.savedListContent;
        
		self.savedListContent = nil;
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}


- (void)viewDidUnload
{
	// Save the state of the search UI so that it can be restored if the view is re-created.
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
	self.savedListContent = self.listContent;
    
	self.listContent = nil;
}


- (void)dealloc
{
	[listContent release];
	[savedListContent release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of the filtered list, otherwise return the count of the main list.
	 */
	//if (tableView == self.searchDisplayController.searchResultsTableView)
	//{
    //    return [self.filteredListContent count];
    //}
	//else
	//{
        return [self.listContent count];
    //}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	Phrase *phrase= nil;
	//if (tableView == self.searchDisplayController.searchResultsTableView)
	//{
    //    phrase = [self.filteredListContent objectAtIndex:indexPath.row];
    //}
	//else
	//{
        phrase = [self.listContent objectAtIndex:indexPath.row];
    //}
	
	cell.textLabel.text = phrase.dictForm;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	Phrase *phrase = [self.listContent objectAtIndex:indexPath.row];
	
	PhraseViewController *viewController = [[PhraseViewController alloc]
											initWithNibName:@"PhraseViewController" bundle:[NSBundle mainBundle]];
	self.phraseView = viewController;
	[self.navigationController pushViewController:self.phraseView animated:YES];
	[viewController release];
	
	NSArray *uncleanResults = [self.uncleanFstInterface getApplyResultsDown:phrase.fstResult];
	NSMutableArray *hiraganaUncleanResults = [[[NSMutableArray alloc] init] autorelease];
	for (id result in uncleanResults) {
		NSArray *newResult = [self.hiraganaFstInterface getApplyResultsDown:result];
		if ([newResult count] > 0) {
			[hiraganaUncleanResults addObject:[newResult objectAtIndex:0]];
		} else {
			[hiraganaUncleanResults addObject:result];
		}
	}
	[phrase setAffixesWithUncleanResults:hiraganaUncleanResults usingAffixArray:allAffixes];
	
	self.phraseView.phrase = phrase;
	[self.phraseView.affixes removeAllObjects];
	self.phraseView.affixes = [phrase.affixes mutableCopy];
	self.phraseView.dictForm.text = phrase.dictForm;
	self.phraseView.enteredForm.text = self.savedSearchTerm;
	self.phraseView.dispPos.text = phrase.dispPos;
	
}

#pragma mark -
#pragma mark Format Search String
- (NSString*)formatSearchString:(NSString*)stringToFormat
{
	NSArray *results = [self.romajiFstInterface getApplyResultsDown:stringToFormat];
	if ([results count] <= 0 && ([[results objectAtIndex:0] length] == 0 || [[results objectAtIndex:0] isEqualToString:@"\n"])) {
		return stringToFormat;
	} else {
		return [results objectAtIndex:0];
	}
}

#pragma mark -
#pragma mark Format Search String
- (NSString*)convertToHiragana:(NSString*)stringToFormat
{
	NSArray *results = [self.hiraganaFstInterface getApplyResultsDown:stringToFormat];
	if ([results count] <= 0 && ([[results objectAtIndex:0] length] == 0 || [[results objectAtIndex:0] isEqualToString:@"\n"])) {
		return stringToFormat;
	} else {
		return [results objectAtIndex:0];
	}
}

#pragma mark -
#pragma mark FST Results
- (void)generateFSTResults:(NSString*)searchText
{
	// Clear the previous list
	[self.listContent removeAllObjects];
	
	// Format the input string
	self.savedSearchTerm = searchText;
	searchText = [self formatSearchString:searchText];
	
	NSArray *searchTextArray = [searchText componentsSeparatedByString:@"\n"];
	
	// Loop
	for (NSString *searchItem in searchTextArray) {
		if ([searchItem length] != 0) {
			NSArray *results = [self.fstInterface getApplyResultsUp:searchItem];
			if ([results count] > 0) {
				// Loop
				for (NSString *result in results) {
					if ([result length] != 0) {
						// Add a new ones
						Phrase *phrase = [Phrase initWithFSTResult:result];
						phrase.dictForm = [self convertToHiragana:phrase.dictForm];
						[self.listContent addObject:phrase];
					}
				}
			}
		}
	}
}
#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
//scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	//[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Phrase *phrase in listContent)
	{
		//if ([scope isEqualToString:@"All"] || [product.type isEqualToString:scope])
		//{
			NSComparisonResult result = [phrase.dictForm compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				//[self.filteredListContent addObject:phrase];
            }
		//}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self filterContentForSearchText:searchString scope:
	//		[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
	//[self filterContentForSearchText:searchString];
	
	[self generateFSTResults:searchString];
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //[self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	//		[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
	[self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end

