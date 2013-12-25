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
#import "TouchXML.h"

@interface Map : NSObject
{
	NSMapTable* tiles;
	NSMutableArray* anchors;
}

@property (nonatomic, readonly) BOOL isRectangular;
@property (nonatomic, readonly) Vector minimumCoordinates;
@property (nonatomic, readonly) Vector maximumCoordinates;
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readwrite) Anchor* baseAnchor;
@property (nonatomic, readonly) NSUInteger anchorCount;
@property (nonatomic, readonly) NSMutableDictionary* metadata;

// Initializers
- (id)initRectangularWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;
- (id)initWithXmlElement:(CXMLElement*)xmlElement;

// Getting information
- (Tile*)tileAt:(Vector)location;
- (BOOL)isLocationEmpty:(Vector)location;
- (NSUInteger)anchorCount;
- (Anchor*)anchorAtIndex:(NSUInteger)index;
- (BOOL)containsCoordinates:(Vector)coordinates;
- (BOOL)containsCoordinates:(Vector)coordinates inBand:(NSUInteger)band;

// Modification
- (void)addTile:(Tile*)tile at:(Vector)location;
- (void)removeTileAt:(Vector)location;
- (void)addAnchor:(Anchor*)anchor;
- (void)removeAnchorAt:(NSUInteger)index;
- (BOOL)placeMap:(Map*)map atAnchorIndexed:(NSUInteger)index force:(BOOL)forcePlace;

@end
