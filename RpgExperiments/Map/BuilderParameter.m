//
//  BuilderParameter.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 8.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "BuilderParameter.h"

@interface BuilderParameter ()

@property (nonatomic, readwrite) void* variable;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) NSNumber* defaultValue;
@property (nonatomic, readwrite) CFNumberType type;

@end

@implementation BuilderParameter

+ (BuilderParameter*)intParameter:(void*)variable withName:(NSString*)name andDefaultValue:(int)value
{
	BuilderParameter* parameter = [[BuilderParameter alloc] init];
	parameter.variable = variable;
	parameter.name = name;
	parameter.defaultValue = [NSNumber numberWithInt:value];
	parameter.type = kCFNumberIntType;
	return parameter;
}

+ (BuilderParameter*)floatParameter:(void*)variable withName:(NSString*)name andDefaultValue:(float)value
{
	BuilderParameter* parameter = [[BuilderParameter alloc] init];
	parameter.variable = variable;
	parameter.name = name;
	parameter.defaultValue = [NSNumber numberWithFloat:value];
	parameter.type = kCFNumberFloatType;
	return parameter;
}

+ (BuilderParameter*)boolParameter:(void*)variable withName:(NSString*)name andDefaultValue:(BOOL)value
{
	BuilderParameter* parameter = [[BuilderParameter alloc] init];
	parameter.variable = variable;
	parameter.name = name;
	parameter.defaultValue = [NSNumber numberWithBool:value];
	parameter.type = kCFNumberCharType;
	return parameter;
}

@end
