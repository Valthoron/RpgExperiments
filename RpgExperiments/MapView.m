//
//  MapView.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 01.05.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "MapView.h"

static float const tileSize = 20.f;

@implementation MapView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self)
	{
		tileSize = 10;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext* context = [NSGraphicsContext currentContext];
	[context setShouldAntialias:NO];
	
	CGContextRef contextRef = (CGContextRef)context.graphicsPort;
	CGContextSelectFont(contextRef, "Arial", 0.5, kCGEncodingMacRoman);
	
	[context saveGraphicsState];
	
	for (NSUInteger v = 0; v < map.height; v++)
	{
		for (NSUInteger u = 0; u < map.width; u++)
		{
			Tile* tile = [map tileAt:MakeCoordinate(u, v)];
			CGRect tileBounds = NSMakeRect(3 + (u * tileSize), 3 + (v * tileSize), tileSize, tileSize);
			
			switch (tile.tileId)
			{
				case 1:
					[[NSColor redColor] set];
					CGContextFillRect(contextRef, tileBounds);
					break;
					
				case 2:
					[[NSColor orangeColor] set];
					CGContextFillRect(contextRef, tileBounds);
					break;
					
				case 3:
					[[NSColor greenColor] set];
					CGContextFillRect(contextRef, tileBounds);
					break;
					
				case 4:
					[[NSColor blueColor] set];
					CGContextFillRect(contextRef, tileBounds);
					break;
					
				default:
					break;
			}
			
			[[NSColor lightGrayColor] set];
			
			if (tile.sectionId != 0)
			{
				NSString* sectionString = [NSString stringWithFormat:@"%ld", (unsigned long)tile.sectionId];
				CGContextShowTextAtPoint(contextRef, tileBounds.origin.x + 2, tileBounds.origin.y + 2, sectionString.UTF8String, sectionString.length);
			}
			
			CGContextStrokeRect(contextRef, tileBounds);
		}
	}
	
	[context restoreGraphicsState];
}

- (void)setMap:(Map*)aMap
{
	map = aMap;
	
	CGRect frame = self.frame;
	frame.size.width = (map.width * tileSize) + 7;
	frame.size.height = (map.height * tileSize) + 7;
	self.frame = frame;
	
	[self setNeedsDisplay:YES];
}

- (void)setTileSize:(NSUInteger)theTileSize
{
	tileSize = theTileSize;
	
	[self setNeedsDisplay:YES];
}

@end
