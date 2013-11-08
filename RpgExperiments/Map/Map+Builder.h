//
//  Map+Builder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Map.h"
#import "Tile+Builder.h"

@interface Map ()

@property (nonatomic, readwrite) NSString* builderName;
@property (nonatomic, readwrite) NSString* builderConfigurationHash;
@property (nonatomic, readwrite) NSUInteger builderSeed;

- (void)iterateTilesUsingBlock:(void (^)(Tile* tile))block;

@end
