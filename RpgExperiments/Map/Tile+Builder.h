//
//  Tile+Builder.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 07.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "Tile.h"

@interface Tile ()

@property (nonatomic) NSUInteger builderData1;
@property (nonatomic) NSUInteger builderData2;
@property (nonatomic) float builderData3;

- (void)resetBuilderData;

@end
