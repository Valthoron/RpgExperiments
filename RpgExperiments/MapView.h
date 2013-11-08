//
//  MapView.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Map.h"

@interface MapView : NSView
{
	NSUInteger tileSize;
	Map* map;
}

- (void)setMap:(Map*)aMap;
- (void)setTileSize:(NSUInteger)theTileSize;

@end
