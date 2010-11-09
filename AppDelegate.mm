//
//  Phrase.h
//  Bunpou
//
//  Created by Dougal Graham on 09-12-22.
//  Copyright 2009 JET. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Phrase.h"

@implementation AppDelegate;

@synthesize window, navController;

- (void)dealloc
{
	[navController release];
    [window release];
    [super dealloc];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // Create and configure the window, navigation controller, and main view controller.
	
	// Create the master list for the main view controller.
	NSMutableArray *listContent = [[NSMutableArray alloc] init];
	
	// Create and configure the main view controller.
	MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	mainViewController.listContent = listContent;
	[listContent release];
	
	// Add create and configure the navigation controller.
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	self.navController = navigationController;
	[navigationController release];
	
	// Configure and display the window.
	[window addSubview:navController.view];
	[window makeKeyAndVisible];
	[mainViewController release];
}


@end
