/*
 *  xfsm_interface.h
 *  Bunpou
 *
 *  Created by Dougal Graham on 10-02-04.
 *  Copyright 2010 JET. All rights reserved.
 *
 */

#import <string>
#include "xfsm_api.h"

using namespace std;

namespace XFSM {
	class XFSMInterface
	{
	private:
		FST_CNTXTptr fst_cntxt;
		NETptr net;
		APPLYptr applyer;
		
	public:
		bool initializeWithFSTName(const char *);
		char *getApplyResultsUp(const char *);
		char *getApplyResultsDown(const char *);
		void destroy();
	};
}