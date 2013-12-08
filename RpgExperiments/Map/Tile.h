//
//  Tile.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 24.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"

@interface Tile : NSObject
{
	
}

@property (nonatomic) Coordinate coordinate;
@property (nonatomic) NSUInteger tileId;
@property (nonatomic) NSUInteger roomId;
@property (nonatomic) NSString* tag;

@end
