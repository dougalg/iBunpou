//
//  PhraseViewController.mm
//  Bunpou
//
//  Created by Dougal Graham on 10-05-20.
//  Copyright 2010 JET. All rights reserved.
//

#import "PhraseViewController.h"


@implementation PhraseViewController
@synthesize	phrase,dispPos,affixes,dictForm,enteredForm;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.affixes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"identifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
	}
	Affix *curAffix = [self.affixes objectAtIndex:indexPath.row];
	NSLog(@"%@", curAffix.fstCode);
	
	// Format the sForms to go in the textLabel slot
	NSMutableString *tempString = [[[NSMutableString alloc] init] autorelease];
	for (id sForm in curAffix.sForms) {
		[tempString appendString:sForm];
		[tempString appendString:@"\n"];
	}
	
	cell.textLabel.text = tempString;
	cell.detailTextLabel.text = curAffix.hFormShort;
	
	// Set color and font size for the affix labels
	cell.textLabel.textColor = cell.detailTextLabel.textColor;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
	cell.textLabel.font = [UIFont systemFontOfSize:17];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Suffixes";
}	 

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
