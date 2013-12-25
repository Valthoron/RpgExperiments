//
//  DungeonBuilder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"

@interface DungeonBuilder : Builder
{
	NSMutableDictionary* rooms;
	NSMutableDictionary* roomGroups;
	
	NSMutableArray* startRules;
	NSMutableArray* rules;
	NSMutableArray* terminateRules;
	
	NSMutableDictionary* variables;
	
	NSMutableDictionary* anchorTries;
	
	int iterationLimit;
	int anchorTryLimit;
	NSString* xmlPath;
}

@end
