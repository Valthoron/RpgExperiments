//
//  Tile.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 24.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@interface Tile : NSObject
{
	
}

//@property (nonatomic) Vector location;
@property (nonatomic) NSUInteger type;
@property (nonatomic) NSUInteger roomId;
@property (nonatomic) NSString* tag;

+ (Tile*)tileWithType:(NSUInteger)type;

@end
