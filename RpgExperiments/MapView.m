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

- (CGRect)tileBounds:(Vector)location origin:(Vector)origin;
{
	return CGRectMake(23 + ((location.x - origin.x) * tileSize), 23 + ((location.y - origin.y) * tileSize), tileSize, tileSize);
}

- (void)drawAnchor:(Anchor*)anchor inContext:(CGContextRef)ctx fill:(BOOL)fill
{
	CGRect anchorBounds = [self tileBounds:anchor.location origin:map.minimumCoordinates];
	
	CGContextSaveGState(ctx);
	
	CGContextSetStrokeColorWithColor(ctx, [NSColor blackColor].CGColor);
	CGContextSetFillColorWithColor(ctx, [NSColor blackColor].CGColor);
	
	CGContextTranslateCTM(ctx, anchorBounds.origin.x + (anchorBounds.size.width / 2), anchorBounds.origin.y + (anchorBounds.size.height / 2));
	CGContextRotateCTM(ctx, -anchor.direction * M_PI_2);
	CGContextScaleCTM(ctx, tileSize / 100.0f, tileSize / 100.0f);
	
	CGContextMoveToPoint(ctx, 0, -20);
	CGContextAddLineToPoint(ctx, 20, -80);
	CGContextAddLineToPoint(ctx, -20, -80);
	CGContextClosePath(ctx);
	
	if (fill)
		CGContextFillPath(ctx);
	else
		CGContextStrokePath(ctx);
	
	CGContextRestoreGState(ctx);
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
	if (map == nil)
		return;
	
	CGContextSaveGState(ctx);
	
	CGContextSetShouldAntialias(ctx, false);
	CGContextSelectFont(ctx, "Arial", 10, kCGEncodingMacRoman);
	CGContextSetStrokeColorWithColor(ctx, [NSColor lightGrayColor].CGColor);
	
	for (NSInteger v = map.minimumCoordinates.y; v <= map.maximumCoordinates.y; v++)
	{
		for (NSInteger u = map.minimumCoordinates.x; u <= map.maximumCoordinates.x; u++)
		{
			Vector location = MakeVector(u, v);
			Tile* tile = [map tileAt:MakeVector(u, v)];
			
			if (tile == nil)
				continue;
			
			CGRect tileBounds = [self tileBounds:location origin:map.minimumCoordinates];
			
			switch (tile.type)
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
			
			NSString* text = [NSString stringWithFormat:@"%lu", (unsigned long)tile.type];
			
			if (tile.tag != nil)
			{
				if (![tile.tag isEqualToString:@""])
				{
					text = [text stringByAppendingFormat:@"/%@", tile.tag];
				}
			}
			
			CGContextShowTextAtPoint(ctx, tileBounds.origin.x + 2, tileBounds.origin.y + 2, [text UTF8String], text.length);
			
			CGContextStrokeRect(ctx, tileBounds);
		}
	}
	
	for (NSUInteger i = 0; i < map.anchorCount; i++)
	{
		[self drawAnchor:[map anchorAtIndex:i] inContext:ctx fill:NO];
	}
	
	[self drawAnchor:map.baseAnchor inContext:ctx fill:YES];
	
	CGContextRestoreGState(ctx);
}

- (void)setMap:(Map*)aMap
{
	map = aMap;
	
	CGRect frame = self.frame;
	frame.size.width = (map.width * tileSize) + 27;
	frame.size.height = (map.height * tileSize) + 27;
	self.frame = frame;
	
	mapLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
	
	[self setNeedsDisplay:YES];
}

- (void)setTileSize:(NSUInteger)theTileSize
{
	tileSize = theTileSize;
	
	CGRect frame = self.frame;
	frame.size.width = (map.width * tileSize) + 27;
	frame.size.height = (map.height * tileSize) + 27;
	self.frame = frame;
	
	mapLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
	
	[self setNeedsDisplay:YES];
}

- (void)setNeedsDisplay:(BOOL)flag
{
	[super setNeedsDisplay:flag];
	[mapLayer setNeedsDisplay];
}

@end
