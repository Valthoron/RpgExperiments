//
//  DungeonBuilderRule.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 20.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "DungeonBuilderRule.h"
#import "DungeonBuilderRuleHelpers.h"

@implementation DungeonBuilderRule

- (id)initWithXmlElement:(CXMLElement*)xmlElement
{
	self = [super init];
	
	if (self)
	{
		xml = [NSString stringWithString:xmlElement.XMLString];
		
		prerequisites = [[NSMutableArray alloc] init];
		results = [[NSMutableArray alloc] init];
		
		CXMLNode* roomAttributeNode = [xmlElement attributeForName:@"room"];
		
		if (roomAttributeNode != nil)
		{
			_room = [roomAttributeNode stringValue];
			_group = nil;
		}
		else
		{
			_room = nil;
			_group = [[xmlElement attributeForName:@"group"] stringValue];
		}
		
		_anchorType = [[[xmlElement attributeForName:@"anchortype"] stringValue] integerValue];
		_placeRoom = [[xmlElement attributeForName:@"place"] stringValue];
		
		// =======
		// Weight
		// =======
		CXMLElement* weightElement = (CXMLElement*)[xmlElement nodeForXPath:@"weight" error:nil];
		
		if (weightElement == nil)
		{
			weightVariable = nil;
			_weight = 1;
		}
		else
		{
			CXMLNode* valueAttribute = [weightElement attributeForName:@"value"];
			CXMLNode* variableAttribute = [weightElement attributeForName:@"variable"];
			
			if ((valueAttribute != nil) && (variableAttribute == nil))
			{
				_weight = [[valueAttribute stringValue] integerValue];
				weightVariable = nil;
			}
			else if ((valueAttribute == nil) && (variableAttribute != nil))
			{
				_weight = 1;
				weightVariable = [variableAttribute stringValue];
			}
			else
			{
				_weight = 1;
				weightVariable = nil;
			}
		}
		
		// ==============
		// Prerequisites
		// ==============
		NSArray* prerequisiteElements = [xmlElement nodesForXPath:@"prerequisite" error:nil];
		
		for (CXMLElement* prerequisiteElement in prerequisiteElements)
		{
			DungeonBuilderRulePrerequisite* prerequisite = [[DungeonBuilderRulePrerequisite alloc] init];
			
			prerequisite.variable = [[prerequisiteElement attributeForName:@"variable"] stringValue];
			
			NSString* comparison = [[prerequisiteElement attributeForName:@"comparison"] stringValue];
			
			if ([comparison isEqualToString:@"equal"])
				prerequisite.comparison = ComparisonEqual;
			else if ([comparison isEqualToString:@"notequal"])
				prerequisite.comparison = ComparisonNotEqual;
			else if ([comparison isEqualToString:@"less"])
				prerequisite.comparison = ComparisonLess;
			else if ([comparison isEqualToString:@"lessequal"])
				prerequisite.comparison = ComparisonLessEqual;
			else if ([comparison isEqualToString:@"greater"])
				prerequisite.comparison = ComparisonGreater;
			else if ([comparison isEqualToString:@"greaterequal"])
				prerequisite.comparison = ComparisonGreaterEqual;
			
			prerequisite.value = [[[prerequisiteElement attributeForName:@"value"] stringValue] integerValue];
			
			[prerequisites addObject:prerequisite];
		}
		
		// ========
		// Results
		// ========
		NSArray* resultElements = [xmlElement nodesForXPath:@"result" error:nil];
		
		for (CXMLElement* resultElement in resultElements)
		{
			DungeonBuilderRuleResult* result = [[DungeonBuilderRuleResult alloc] init];
			
			result.variable = [[resultElement attributeForName:@"variable"] stringValue];
			
			NSString* operation = [[resultElement attributeForName:@"operation"] stringValue];
			
			if ([operation isEqualToString:@"set"])
				result.operation = OperationSet;
			else if ([operation isEqualToString:@"add"])
				result.operation = OperationAdd;
			
			result.value = [[[resultElement attributeForName:@"value"] stringValue] integerValue];
			
			[results addObject:result];
		}
	}
	
	return self;
}

- (void)evaluateWithVariables:(NSDictionary*)variables
{
	// Check prerequisites
	for (DungeonBuilderRulePrerequisite* prerequisite in prerequisites)
	{
		NSNumber* valueNumber = [variables objectForKey:prerequisite.variable];
		
		if (valueNumber == nil)
		{
			_meetsPrerequisites = NO;
		}
		else
		{
			NSInteger value = [valueNumber integerValue];
			
			switch (prerequisite.comparison)
			{
				case ComparisonEqual:
					_meetsPrerequisites = (value == prerequisite.value);
					break;
					
				case ComparisonNotEqual:
					_meetsPrerequisites = (value == prerequisite.value);
					
				case ComparisonLess:
					_meetsPrerequisites = (value < prerequisite.value);
					break;
					
				case ComparisonLessEqual:
					_meetsPrerequisites = (value <= prerequisite.value);
					break;
					
				case ComparisonGreater:
					_meetsPrerequisites = (value > prerequisite.value);
					break;
					
				case ComparisonGreaterEqual:
					_meetsPrerequisites = (value >= prerequisite.value);
					break;
					
				default:
					break;
			}
		}
		
		if (_meetsPrerequisites == NO)
			return;
	}
	
	_meetsPrerequisites = YES;
	
	// Calculate weight if a weight variable is specified
	if (weightVariable != nil)
	{
		NSNumber* valueNumber = [variables objectForKey:weightVariable];
		
		if (valueNumber == nil)
		{
			// Assume 0
			_weight = 0;
		}
		else
		{
			NSInteger weight = [valueNumber integerValue];
			
			if (weight < 0)
				_weight = 0;
			else
				_weight = weight;
		}
	}
}

- (void)applyResultsToVariables:(NSMutableDictionary*)variables
{
	for (DungeonBuilderRuleResult* result in results)
	{
		switch (result.operation)
		{
			case OperationSet:
			{
				[variables setObject:[NSNumber numberWithInteger:result.value] forKey:result.variable];
				break;
			}
				
			case OperationAdd:
			{
				// Assume 0 if the variable doesn't exist
				NSInteger value = result.value;
				
				NSNumber* valueNumber = [variables objectForKey:result.variable];
				
				// Add the existing value if it acutally exists
				if (valueNumber != nil)
				{
					value = value + [valueNumber integerValue];
				}
				
				[variables setObject:[NSNumber numberWithInteger:value] forKey:result.variable];
				
				break;
			}
				
			default:
				break;
		}
	}
}

- (NSString*)debugDescription
{
	return xml;
}

@end

@implementation DungeonBuilderRulePrerequisite
@end

@implementation DungeonBuilderRuleResult
@end
