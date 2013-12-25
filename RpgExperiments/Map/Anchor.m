//
//  Anchor.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 11.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Anchor.h"

@implementation Anchor

+ (Anchor*)anchorAt:(Vector)location inDirection:(MainDirection)direction withName:(NSString*)name andSubtype:(NSInteger)type
{
	Anchor* anchor = [[Anchor alloc] init];
	
	anchor.location = location;
	anchor.direction = direction;
	anchor.name = name;
	anchor.type = type;
	
	return anchor;
}

// I know overriding this requires -hash to be overridden too. But I won't do that.
- (BOOL)isEqual:(id)object
{
	Anchor* other = (Anchor*)object;
	
	return ((_location.x == other.location.x) &&
			(_location.y == other.location.y) &&
			(_direction == other.direction) &&
			(_type == other.type) &&
			[_name isEqualToString:other.name]);
}

- (id)copyWithZone:(NSZone*)zone
{
	Anchor* anchorCopy = [[Anchor alloc] init];
	
	anchorCopy.location = MakeVector(_location.x, _location.y);
	anchorCopy.direction = _direction;
	anchorCopy.name = [NSString stringWithString:_name];
	anchorCopy.type = _type;
	
	return anchorCopy;
}

@end
