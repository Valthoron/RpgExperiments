//
//  Map.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 23.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
#import "Tile.h"

@interface Map : NSObject
{
	NSArray* tiles;
}

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) NSString* builderName;
@property (nonatomic, readonly) NSString* builderConfigurationHash;
@property (nonatomic, readonly) NSUInteger builderSeed;

- (id)initWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;
- (Tile*)tileAt:(Coordinate)coordinate;

@end
