//
//  Map.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"
#import "Tile.h"
#import "Directions.h"
#import "Anchor.h"

@interface Map : NSObject
{
	NSMutableArray* tiles;
	Anchor anchor;
	NSMutableArray* openAnchors;
}

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) NSMutableDictionary* metadata;

- (id)initWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;

- (Tile*)tileAt:(Vector)coordinate;
- (void)addTile:(Tile*)tile;
- (void)removeTileAt:(Vector)coordinate;

- (void)placeMapAt:(Anchor)openAnchor;

- (BOOL)containsCoordinate:(Vector)coordinate;
- (BOOL)containsCoordinate:(Vector)coordinate withinBand:(NSUInteger)band;

- (void)rotate:(Rotation)direction;
- (void)realignOrigin;

@end
