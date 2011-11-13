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

@synthesize listContent, savedListContent, savedSearchTerm, searchWasActive, phraseView, allAffixes;


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
	XFSMInterface hiraganaFstInterface;
	const char *path = "kr_converter.fst";
	// Reformat the path while passing it to the func
	bool success = hiraganaFstInterface.initializeWithFSTName(path);
	if (success) {
		// What here?
		char *results = hiraganaFstInterface.getApplyResultsDown([stringToFormat UTF8String]);
		NSString *nsresults = [[[NSString alloc] init] autorelease];
		if (results) {
			nsresults = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
		}
		
		hiraganaFstInterface.destroy();
		
		if ([nsresults length] == 0 || [nsresults isEqualToString:@"\n"]) {
			return stringToFormat;
		} else {
			return nsresults;
		}
	} else {
		// Throw errors
		return stringToFormat;
	}
}

#pragma mark -
#pragma mark Format Search String
- (NSString*)convertToHiragana:(NSString*)stringToFormat
{
	XFSMInterface hiraganaFstInterface;
	const char *path = "rk_converter.fst";
	// Reformat the path while passing it to the func
	bool success = hiraganaFstInterface.initializeWithFSTName(path);
	if (success) {
		// What here?
		char *results = hiraganaFstInterface.getApplyResultsDown([stringToFormat UTF8String]);
		NSString *nsresults = [[[NSString alloc] init] autorelease];
		if (results) {
			nsresults = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
		}
		
		hiraganaFstInterface.destroy();
		
		if ([nsresults length] == 0 || [nsresults isEqualToString:@"\n"]) {
			return stringToFormat;
		} else {
			return nsresults;
		}
	} else {
		// Throw errors
		return stringToFormat;
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
	
	// Set up the FST interfacer
	// First, set the path to the FST
	const char *path = "full.fst";
	XFSMInterface fstInterface;
	
	// Reformat the path while passing it to the func
	bool success = fstInterface.initializeWithFSTName(path);
	
	if (success) {
		// Huh?
	} else {
		// Throw errors
	}
	
	// Loop
	for (NSString *searchItem in searchTextArray) {
		if ([searchItem length] != 0) {
			//fprintf(stderr, "%s", [searchItem UTF8String]);
			char *results = fstInterface.getApplyResultsUp([searchItem UTF8String]);
			NSString *nsresults = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
			
			// Split by lines
			NSArray *resultsArray = [nsresults componentsSeparatedByString:@"\n"];
			
			// Loop
			for (NSString *result in resultsArray) {
				if ([result length] != 0) {
					// Add a new ones
					Phrase *phrase = [Phrase initWithFSTResult:result andAffixArray:allAffixes];
					phrase.dictForm = [self convertToHiragana:phrase.dictForm];
					[self.listContent addObject:phrase];
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

