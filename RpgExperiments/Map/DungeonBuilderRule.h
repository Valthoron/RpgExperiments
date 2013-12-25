//
//  DungeonBuilderRule.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 20.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface DungeonBuilderRule : NSObject
{
	NSMutableArray* prerequisites;
	NSMutableArray* results;
	
	NSString* weightVariable;
	
	NSString* xml;
}

@property (nonatomic) NSString* room;
@property (nonatomic) NSString* group;
@property (nonatomic) NSInteger anchorType;
@property (nonatomic) NSString* placeRoom;

@property (nonatomic, readonly) BOOL meetsPrerequisites;
@property (nonatomic, readonly) NSUInteger weight;

- (id)initWithXmlElement:(CXMLElement*)xmlElement;
- (void)evaluateWithVariables:(NSDictionary*)variables;
- (void)applyResultsToVariables:(NSMutableDictionary*)variables;

@end
