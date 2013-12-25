//
//  DungeonBuilder.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "DungeonBuilder.h"
#import "DungeonBuilderRule.h"
#import "Builder_Subclass.h"
#import "TouchXML.h"

const NSString* kMapWidthVariable = @"_mapWidth";
const NSString* kMapHeightVariable = @"_mapHeight";
const NSString* kAnchorCountVariable = @"_anchorCount";

@implementation DungeonBuilder

// =========================
#pragma mark - Initializers
// =========================

- (id)init
{
    self = [super init];
	
    if (self)
	{
		[self setDefaultValue:250 forIntParameter:@"iterationLimit"];
		[self setDefaultValue:10 forIntParameter:@"anchorTryLimit"];
		[self setDefaultValue:[@"~/Documents/Builder.xml" stringByExpandingTildeInPath] forStringParameter:@"xmlPath"];
    }
	
    return self;
}

// ====================
#pragma mark - Methods
// ====================

- (void)buildMap
{
	iterationLimit = [self valueForIntParameter:@"iterationLimit"];
	anchorTryLimit = [self valueForIntParameter:@"anchorTryLimit"];
	xmlPath = [self valueForStringParameter:@"xmlPath"];
	
	rooms = [[NSMutableDictionary alloc] init];
	roomGroups = [[NSMutableDictionary alloc] init];
	
	startRules = [[NSMutableArray alloc] init];
	rules = [[NSMutableArray alloc] init];
	terminateRules = [[NSMutableArray alloc] init];
	
	variables = [[NSMutableDictionary alloc] init];
	
	anchorTries = [[NSMutableDictionary alloc] init];
	
	@autoreleasepool
	{
		CXMLNode* dataNode;
		NSArray* nodes;
		
		// =========
		// Read XML
		// =========
		NSData* xmlData = [NSData dataWithContentsOfFile:xmlPath];
		CXMLDocument* xmlDocument = [[CXMLDocument alloc] initWithData:xmlData options:0 error:nil];
		
		dataNode = [xmlDocument nodeForXPath:@"/builderdata" error:nil];
		
		// ===========
		// Read rooms
		// ===========
		nodes = [dataNode nodesForXPath:@"rooms/room" error:nil];
		
		for (CXMLElement* roomElement in nodes)
		{
			Map* room = [[Map alloc] initWithXmlElement:roomElement];
			
			NSString* roomName = [[roomElement attributeForName:@"name"] stringValue];
			
			[rooms setObject:room forKey:roomName];
			
			CXMLNode* roomGroupNode = [roomElement attributeForName:@"group"];
			
			if (roomGroupNode != nil)
				[roomGroups setObject:[roomGroupNode stringValue] forKey:roomName];
		}
		
		// ===========
		// Read rules
		// ===========
		nodes = [dataNode nodesForXPath:@"rules/startrule" error:nil];
		
		for (CXMLElement* startRuleElement in nodes)
		{
			[startRules addObject:[[DungeonBuilderRule alloc] initWithXmlElement:startRuleElement]];
		}
		
		nodes = [dataNode nodesForXPath:@"rules/rule" error:nil];
		
		for (CXMLElement* ruleElement in nodes)
		{
			[rules addObject:[[DungeonBuilderRule alloc] initWithXmlElement:ruleElement]];
		}
		
		nodes = [dataNode nodesForXPath:@"rules/terminaterule" error:nil];
		
		for (CXMLElement* terminateRuleElement in nodes)
		{
			[terminateRules addObject:[[DungeonBuilderRule alloc] initWithXmlElement:terminateRuleElement]];
		}
	}
	
	// ======================
	// Place a starting room
	// ======================
	DungeonBuilderRule* startRule = [self selectRuleFrom:startRules forAnchor:nil];
	Map* startRoom = [rooms objectForKey:startRule.placeRoom];
	map = [startRoom copy];
	[startRule applyResultsToVariables:variables];
	
	// ============
	// Place rooms
	// ============
	int iteration = 0;
	
	while (map.anchorCount > 0)
	{
		// =================
		// Select an anchor
		// =================
		NSUInteger anchorIndex = [random nextUniformIntWithUpperBound:(unsigned int)map.anchorCount];
		
		Anchor* anchor = [map anchorAtIndex:anchorIndex];
		
		// ==============
		// Select a rule
		// ==============
		DungeonBuilderRule* rule;
		BOOL forceRule;
		
		if ([self triesForAnchor:anchor] < anchorTryLimit)
		{
			rule = [self selectRuleFrom:rules forAnchor:anchor];
			forceRule = NO;
		}
		else
		{
			rule = [self selectRuleFrom:terminateRules forAnchor:anchor];
			forceRule = YES;
		}
		
		// ========================================
		// Attempt to place room according to rule
		// ========================================
		BOOL ruleSuccessful = NO;
		
		if (rule != nil)
		{
			Map* placeRoom = [rooms objectForKey:rule.placeRoom];
			
			ruleSuccessful = [map placeMap:placeRoom atAnchorIndexed:anchorIndex force:forceRule];
		}
		else if (forceRule)
		{
			// No terminating rule found
			break;
		}
		
		if (ruleSuccessful)
		{
			// =================
			// Update variables
			// =================
			[rule applyResultsToVariables:variables];
			
			// Update built-in variables
			[variables setObject:[NSNumber numberWithInteger:[map width]] forKey:kMapWidthVariable];
			
			[variables setObject:[NSNumber numberWithInteger:[map height]] forKey:kMapHeightVariable];
			
			[variables setObject:[NSNumber numberWithInteger:map.anchorCount] forKey:kAnchorCountVariable];
			
			[self clearTriesForAnchor:anchor];
		}
		else
		{
			// =========================
			// Track impossible anchors
			// =========================
			[self incrementTriesForAnchor:anchor];
		}
		
		iteration++;
		
		if (iteration >= iterationLimit)
			break;
	}
	
	// =======================
	// Release unused objects
	// =======================
	rooms = nil;
	roomGroups = nil;
	
	startRules = nil;
	rules = nil;
	terminateRules = nil;
	
	variables = nil;
	
	anchorTries = nil;
}

// ==============================
#pragma mark - Utility Functions
// ==============================

- (DungeonBuilderRule*)selectRuleFrom:(NSArray*)ruleSet forAnchor:(Anchor*)anchor
{
	NSString* roomName = anchor.name;
	NSString* roomGroup = [roomGroups objectForKey:anchor.name];
	
	NSMutableArray* eligibleRules = [[NSMutableArray alloc] init];
	NSUInteger totalWeight = 0;
	
	for (DungeonBuilderRule* rule in ruleSet)
	{
		// Check if the rule is applicable to the anchor, if given
		if (anchor != nil)
		{
			if (rule.room != nil)
			{
				if (([rule.room isEqualToString:roomName] == NO) && ([rule.room isEqualToString:@"*"] == NO))
					continue;
			}
			else
			{
				if (([rule.group isEqualToString:roomGroup] == NO) && ([rule.group isEqualToString:@"*"] == NO))
					continue;
			}
		}
		
		// Check if the rule meets variable prerequisites
		[rule evaluateWithVariables:variables];
		
		if ((rule.meetsPrerequisites == NO) || (rule.weight == 0))
			continue;
		
		// The rule passed the tests if we're here
		[eligibleRules addObject:rule];
		totalWeight += rule.weight;
	}
	
	if (eligibleRules.count == 0)
		return nil;
	
	NSUInteger roll = [random nextUniformIntWithUpperBound:(unsigned int)totalWeight];
		
	DungeonBuilderRule* selectedRule = [eligibleRules objectAtIndex:0];
	NSUInteger index = 0;
	
	while (roll >= selectedRule.weight)
	{
		roll -= selectedRule.weight;
		index++;
		selectedRule = [eligibleRules objectAtIndex:index];
	}
	
	return selectedRule;
}

- (int)triesForAnchor:(Anchor*)anchor
{
	NSValue* key = [NSValue valueWithPointer:(__bridge const void *)(anchor)];
	
	int tries = 0;
	
	NSNumber* triesValue = [anchorTries objectForKey:key];
	
	if (triesValue != nil)
		tries = [triesValue intValue];
	
	return tries;
}

- (void)incrementTriesForAnchor:(Anchor*)anchor
{
	NSValue* key = [NSValue valueWithPointer:(__bridge const void *)(anchor)];
	
	int tries = 1;
	
	NSNumber* triesValue = [anchorTries objectForKey:key];
	
	if (triesValue != nil)
		tries += [triesValue intValue];
	
	[anchorTries setObject:[NSNumber numberWithInt:tries] forKey:key];
}

- (void)clearTriesForAnchor:(Anchor*)anchor
{
	NSValue* key = [NSValue valueWithPointer:(__bridge const void *)(anchor)];
	
	[anchorTries removeObjectForKey:key];
}

@end
