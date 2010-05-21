
/*
     File: MainViewController.m
 Abstract: Main table view controller for the application.
  Version: 1.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#import "MainViewController.h"
#import "Phrase.h"

@implementation MainViewController

@synthesize listContent, savedListContent, savedSearchTerm, searchWasActive, fstInterface, hiraganaFstInterface, phraseView;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"Search";
	
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
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
	self.fstInterface.destroy();
	
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
    // UNCOMMENT UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	// UNCOMMENT Phrase *phrase = nil;
	//if (tableView == self.searchDisplayController.searchResultsTableView)
	//{
    //    phrase = [self.filteredListContent objectAtIndex:indexPath.row];
    //}
	//else
	//{
	// UNCOMMENT phrase = [self.listContent objectAtIndex:indexPath.row];
    //}
	// UNCOMMENT detailsViewController.title = phrase.dictForm;
    
    // UNCOMMENT [[self navigationController] pushViewController:detailsViewController animated:YES];
    // UNCOMMENT [detailsViewController release];
	
	Phrase *phrase = [self.listContent objectAtIndex:indexPath.row];
	

	PhraseViewController *viewController = [[PhraseViewController alloc]
											initWithNibName:@"PhraseViewController" bundle:[NSBundle mainBundle]];
	self.phraseView = viewController;
	[self.navigationController pushViewController:self.phraseView animated:YES];
	[viewController release];
	
	self.phraseView.phrase = phrase;
	[self.phraseView.affixes removeAllObjects];
	self.phraseView.affixes = [phrase.affixes mutableCopy];
	[self.phraseView.dictForm setText:phrase.dictForm];
	[self.phraseView.enteredForm setText:self.savedSearchTerm];
	[self.phraseView.pos setText:phrase.pos];
	
}

#pragma mark -
#pragma mark Format Search String
- (NSString*)formatSearchString:(NSString*)stringToFormat
{
	char *results = self.hiraganaFstInterface.getApplyResultsDown([stringToFormat UTF8String]);
	NSString *nsresults = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
	if ([nsresults length] == 0 || [nsresults isEqualToString:@"\n"]) {
		return stringToFormat;
	} else {
		return [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
	}
}

#pragma mark -
#pragma mark FST Results
- (void)generateFSTResults:(NSString*)searchText
{
	// Clear the previous list
	[self.listContent removeAllObjects];
	
	// Format the input string
	searchText = [self formatSearchString:searchText];
	self.savedSearchTerm = searchText;
	
	NSArray *searchTextArray = [searchText componentsSeparatedByString:@"\n"];
	
	// Loop
	for (NSString *searchItem in searchTextArray) {
		if ([searchItem length] != 0) {
			//fprintf(stderr, "%s", [searchItem UTF8String]);
			char *results = self.fstInterface.getApplyResultsUp([searchItem UTF8String]);
			NSString *nsresults = [NSString stringWithCString:results encoding:NSUTF8StringEncoding];
			
			// Split by lines
			NSArray *resultsArray = [nsresults componentsSeparatedByString:@"\n"];
			
			// Loop
			for (NSString *result in resultsArray) {
				if ([result length] != 0) {
					// Add a new ones
					Phrase *phrase = [Phrase initWithFSTResult:result];
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

