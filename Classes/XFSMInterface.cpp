/*
 *  xfsm_interface.cpp
 *  Bunpou
 *
 *  Created by Dougal Graham on 10-02-04.
 *  Copyright 2010 JET. All rights reserved.
 *
 */
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "CoreFoundation/CoreFoundation.h"

#include "XFSMInterface.h"
namespace XFSM {
// This initializes the FST and sets up the 2 pointers
// Returns true on success, false on fail
bool XFSMInterface::initializeWithFSTName(const char *fst_name) {
	// Initialize the fst_cntxt variable
	fst_cntxt = initialize_cfsm();
	
	// Check it works
	if (!fst_cntxt || fst_cntxt == NULL) {
		fprintf(stderr, "Cannot initialize FSM context.\n");
		return false;
	} else {
		IY_VERBOSE = FALSE;
		
		//chdir(path);
		
		// recast fst_name as a const char* and append it to the path
		//char *fullFSTDir;
		//fullFSTDir = strcat(path, fst_name);
		
		net = load_net(fst_name, fst_cntxt);
		 
		if (!net || net == NULL) {
			fprintf(stderr, "Cannot load net at '%s'.\n", fst_name);
			return false;
		} else {
			return true;
		}
	}
}

void XFSMInterface::destroy() {
	//free_applyer_complete(applyer);
	//free_network(net);
	//reclaim_cfsm(fst_cntxt);
}

// This will return a character string of unfiltered results
// Does the real work...
char *XFSMInterface::getApplyResultsUp(const char *searchString) {
	char *result;
	
	applyer = init_apply(net, UPPER, fst_cntxt);
	switch_input_side(applyer);
	
	if (applyer == NULL) {
		// Throw error
		fprintf(stderr, "Applyer could not be loaded.\n");
	} else {
		result = apply_to_string(searchString, applyer);
	}
	//fprintf(stderr, "(U) Input: '%s' Result: '%s'\n", searchString, result);
	return result;
}

// This will return a character string of unfiltered results
// Does the real work...
char *XFSMInterface::getApplyResultsDown(const char *searchString) {
	char *result;
	
	applyer = init_apply(net, LOWER, fst_cntxt);
	switch_input_side(applyer);
	
	if (applyer == NULL) {
		// Throw error
		fprintf(stderr, "Applyer could not be loaded.\n");
	} else {
		result = apply_to_string(searchString, applyer);
	}
	//fprintf(stderr, "(U) Input: '%s' Result: '%s'\n", searchString, result);
	return result;
}
}