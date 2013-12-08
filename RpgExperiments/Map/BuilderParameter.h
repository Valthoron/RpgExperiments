//
//  BuilderParameter.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 8.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuilderParameter : NSObject

@property (nonatomic, readonly) void* variable;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSNumber* defaultValue;
@property (nonatomic, readonly) CFNumberType type;

+ (BuilderParameter*)intParameter:(void*)variable withName:(NSString*)name andDefaultValue:(int)value;
+ (BuilderParameter*)floatParameter:(void*)variable withName:(NSString*)name andDefaultValue:(float)value;
+ (BuilderParameter*)boolParameter:(void*)variable withName:(NSString*)name andDefaultValue:(BOOL)value;

@end
