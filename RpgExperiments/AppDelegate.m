//
//  AppDelegate.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 29.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "AppDelegate.h"
#import "Dice.h"
#import "Map.h"
#import "Builder.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self.window setFrame:[[NSScreen mainScreen] visibleFrame] display:YES];
	
	documentView = _scrollView.documentView;
	[documentView setAutoresizingMask:NSViewNotSizable];
	
	mapView = [[MapView alloc] initWithFrame:documentView.frame];
	[documentView addSubview:mapView];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

- (void)presentMapGenerateDialog:(id)sender
{
	mapGenerateDialog = [[MapGenerateDialogController alloc] init];
	[NSApp beginSheet:mapGenerateDialog.window modalForWindow:self.window modalDelegate:self didEndSelector:@selector(mapGenerateDialogDidEnd) contextInfo:NULL];
}

-(void)mapGenerateDialogDidEnd
{
	[NSApp endSheet:mapGenerateDialog.window];
	[mapGenerateDialog.window orderOut:self];
	
	if (mapGenerateDialog.result != nil)
	{
		generateParameters = mapGenerateDialog.result;
		[self generateMap:nil];
	}
				
	mapGenerateDialog = nil;
}

- (IBAction)generateMap:(id)sender
{
	if (generateParameters == nil)
		return;
	
	Builder* builder = [generateParameters objectForKey:@"builder"];
	NSUInteger width = [[generateParameters objectForKey:@"width"] unsignedIntegerValue];
	NSUInteger height = [[generateParameters objectForKey:@"height"] unsignedIntegerValue];
	NSDictionary* configuration = [generateParameters objectForKey:@"configuration"];
	
	map = [builder buildMapWithWidth:width andHeight:height usingConfiguration:configuration];
	
	[mapView setMap:map];
	
	CGRect frame;
	frame.origin = documentView.frame.origin;
	frame.size = mapView.frame.size;
	documentView.frame = frame;
}

- (IBAction)refineMap:(id)sender
{
	
}

- (void)saveMapAsImage:(id)sender
{
	NSString* fileName = [NSString stringWithFormat:@"%@ %u.png", map.builderName, map.builderSeed];
	NSString* details = [NSString stringWithFormat:@"%ld × %ld %@\nSeed:%u\nConfiguration: %@", (unsigned long)map.width, (unsigned long)map.height, map.builderName, map.builderSeed, [map.builderConfiguration debugDescription]];
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString* desktopPath = [paths objectAtIndex:0];
    NSString* filePath = [desktopPath stringByAppendingPathComponent:fileName];
	
	NSImage* image = [[NSImage alloc] initWithSize:mapView.frame.size];
	NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
	NSBitmapImageRep* imageRep = [mapView bitmapImageRepForCachingDisplayInRect:imageRect];
	[mapView cacheDisplayInRect:imageRect toBitmapImageRep:imageRep];
	
	NSGraphicsContext* ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:ctx];
	[details drawInRect:imageRect withAttributes:nil];
	[ctx flushGraphics];
	[NSGraphicsContext restoreGraphicsState];
	
	NSData* imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    [imageData writeToFile:filePath atomically:YES];
	
	[[[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/Grab.aif" byReference:NO] play];
}

@end
