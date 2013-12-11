//
//  MapView.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "MapView.h"

@implementation MapView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self)
	{
		tileSize = 20;
		
		self.layer = [CALayer layer];
		self.wantsLayer = YES;
		
		mapLayer = [CALayer layer];
		mapLayer.delegate = self;
		mapLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
		[self.layer addSublayer:mapLayer];
	}
	
	return self;
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
	CGContextSaveGState(ctx);
	CGContextSetShouldAntialias(ctx, false);
	CGContextSelectFont(ctx, "Arial", 10, kCGEncodingMacRoman);
	CGContextSetStrokeColorWithColor(ctx, [NSColor lightGrayColor].CGColor);
	
	for (NSUInteger v = 0; v < map.height; v++)
	{
		for (NSUInteger u = 0; u < map.width; u++)
		{
			Tile* tile = [map tileAt:MakeVector(u, v)];
			CGRect tileBounds = NSMakeRect(3 + (u * tileSize), 3 + ((map.height - v - 1) * tileSize), tileSize, tileSize);
			
			switch (tile.tileId)
			{
				case 1:
					CGContextSetFillColorWithColor(ctx, [NSColor redColor].CGColor);
					CGContextFillRect(ctx, tileBounds);
					break;
					
				case 2:
					CGContextSetFillColorWithColor(ctx, [NSColor orangeColor].CGColor);
					CGContextFillRect(ctx, tileBounds);
					break;
					
				case 3:
					CGContextSetFillColorWithColor(ctx, [NSColor greenColor].CGColor);
					CGContextFillRect(ctx, tileBounds);
					break;
					
				case 4:
					CGContextSetFillColorWithColor(ctx, [NSColor blueColor].CGColor);
					CGContextFillRect(ctx, tileBounds);
					break;
					
				default:
					break;
			}
			
			CGContextSetFillColorWithColor(ctx, [NSColor blackColor].CGColor);
			
			if (![tile.tag isEqualToString:@""])
			{
				CGContextShowTextAtPoint(ctx, tileBounds.origin.x + 2, tileBounds.origin.y + 2, [tile.tag UTF8String], tile.tag.length);
			}
			
			CGContextStrokeRect(ctx, tileBounds);
		}
	}
	
	CGContextRestoreGState(ctx);
}

- (void)setMap:(Map*)aMap
{
	map = aMap;
	
	CGRect frame = self.frame;
	frame.size.width = (map.width * tileSize) + 7;
	frame.size.height = (map.height * tileSize) + 7;
	self.frame = frame;
	
	mapLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
	
	[self setNeedsDisplay:YES];
	[mapLayer setNeedsDisplay];
}

- (void)setTileSize:(NSUInteger)theTileSize
{
	tileSize = theTileSize;
	
	CGRect frame = self.frame;
	frame.size.width = (map.width * tileSize) + 7;
	frame.size.height = (map.height * tileSize) + 7;
	self.frame = frame;
	
	mapLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
	
	[self setNeedsDisplay:YES];
	[mapLayer setNeedsDisplay];
}

@end
