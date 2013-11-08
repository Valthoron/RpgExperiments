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
#import "CaveBuilder.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	documentView = _scrollView.documentView;
	[documentView setAutoresizingMask:NSViewNotSizable];
	
	mapView = [[MapView alloc] initWithFrame:documentView.frame];
	[documentView addSubview:mapView];
	
	CaveBuilder* caveBuilder = [[CaveBuilder alloc] init];
	//map = [caveBuilder buildMapWithWidth:140 andHeight:70];
	map = [caveBuilder buildMapWithWidth:140 andHeight:70 usingSeed:0];
	[mapView setMap:map];
	
	CGRect frame;
	frame.origin = documentView.frame.origin;
	frame.size = mapView.frame.size;
	documentView.frame = frame;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

- (void)presentMapGenerateDialog:(id)sender
{
	
}

- (void)saveMapAsImage:(id)sender
{
	NSString* fileName = [NSString stringWithFormat:@"%@ %ld.png", map.builderName, (unsigned long)map.builderSeed];
	NSString* details = [NSString stringWithFormat:@"%ld × %ld %@\nConfiguration: %@\nSeed: %ld", (unsigned long)map.width, (unsigned long)map.height, map.builderName, map.builderConfigurationHash, (unsigned long)map.builderSeed];
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString* documentsPath = [paths objectAtIndex:0];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:fileName];
	
	NSImage* image = [[NSImage alloc] initWithSize:mapView.frame.size];
	NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
	
	[image lockFocus];
	[[NSColor controlBackgroundColor] set];
	[NSBezierPath fillRect:imageRect];
	[mapView drawRect:imageRect];
	[details drawInRect:imageRect withAttributes:nil];
	[image unlockFocus];
	
	NSData* imageData = [image TIFFRepresentation];
	NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:imageData];
	imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    [imageData writeToFile:filePath atomically:YES];
	
	[[[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/Grab.aif" byReference:NO] play];
}

@end
