//
//  Builder_BuilderSubclass.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 8.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Builder.h"

@interface Builder ()

- (void)buildMap;
- (void)setDefaultValue:(int)value forIntParameter:(NSString*)name;
- (void)setDefaultValue:(float)value forFloatParameter:(NSString*)name;
- (void)setDefaultValue:(BOOL)value forBoolParameter:(NSString*)name;
- (void)setDefaultValue:(NSString*)value forStringParameter:(NSString*)name;
- (int)valueForIntParameter:(NSString*)name;
- (float)valueForFloatParameter:(NSString*)name;
- (BOOL)valueForBoolParameter:(NSString*)name;
- (NSString*)valueForStringParameter:(NSString*)name;

@end
