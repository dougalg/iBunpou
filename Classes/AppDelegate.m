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
#import "CJSONDeserializer.h"

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
	// Create all the FST instances to pass them to mainViewController later
	// First load the hiragana to romaji conversion FST
	XFSM_Wrap *krFST = [[[XFSM_Wrap alloc] initializeWithFSTName:@"kr_converter"] autorelease];
	// Romaji to hiragana conversion FST
	XFSM_Wrap *rkFST = [[[XFSM_Wrap alloc] initializeWithFSTName:@"rk_converter"] autorelease];
	XFSM_Wrap *fullFST = [[[XFSM_Wrap alloc] initializeWithFSTName:@"full"] autorelease];
	XFSM_Wrap *uncleanFST = [[[XFSM_Wrap alloc] initializeWithFSTName:@"full_unclean"] autorelease];
	
    // Create and configure the window, navigation controller, and main view controller.
	
	// Create the master list for the main view controller.
	NSMutableArray *listContent = [[NSMutableArray alloc] init];
	
	// Create and configure the main view controller.
	MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	mainViewController.listContent = listContent;
	[listContent release];
	
	mainViewController.romajiFstInterface = krFST;
	mainViewController.hiraganaFstInterface = rkFST;
	mainViewController.uncleanFstInterface = uncleanFST;
	mainViewController.fstInterface = fullFST;
	
	// Try out JSON parsing
	// Load the data file
	NSString *path = [[NSBundle mainBundle] pathForResource: @"affixes" ofType: @"json"];
	NSData *data = [NSData dataWithContentsOfFile: path];
	
	// Parse it with the JSON parser
	NSError *theError = nil;
	NSArray *array = [[CJSONDeserializer deserializer] deserializeAsArray:data error:&theError];
	
	// Set the affixes for the mainView
	mainViewController.allAffixes = array;
	
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
