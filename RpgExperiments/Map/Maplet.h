//
//  Maplet.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 8.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Maplet : NSObject
{
	NSMutableArray* tiles;
}

- (void)addTile:(Tile*)tile;

@end
