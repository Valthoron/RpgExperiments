//
//  DungeonBuilderRuleHelpers.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 20.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	ComparisonEqual,
	ComparisonNotEqual,
	ComparisonLess,
	ComparisonLessEqual,
	ComparisonGreater,
	ComparisonGreaterEqual
} Comparison;

typedef enum
{
	OperationSet,
	OperationAdd,
} Operation;

@interface DungeonBuilderRulePrerequisite : NSObject
@property (nonatomic) NSString* variable;
@property (nonatomic) Comparison comparison;
@property (nonatomic) NSInteger value;
@end

@interface DungeonBuilderRuleResult : NSObject
@property (nonatomic) NSString* variable;
@property (nonatomic) Operation operation;
@property (nonatomic) NSInteger value;
@end
