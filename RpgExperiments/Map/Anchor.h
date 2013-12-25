//
//  Anchor.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 10.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Vector.h"
#import "Directions.h"

@interface Anchor : NSObject <NSCopying>

@property (nonatomic) Vector location;
@property (nonatomic) MainDirection direction;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) NSInteger type;

+ (Anchor*)anchorAt:(Vector)location inDirection:(MainDirection)direction withName:(NSString*)name andSubtype:(NSInteger)type;

@end
