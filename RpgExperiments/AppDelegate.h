//
//  AppDelegate.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 29.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapView.h"
#import "MapGenerateDialogController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
	NSView* documentView;
	MapView* mapView;
	Map* map;
	MapGenerateDialogController* mapGenerateDialog;
	NSDictionary* generateParameters;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSScrollView *scrollView;

- (IBAction)presentMapGenerateDialog:(id)sender;
- (IBAction)saveMapAsImage:(id)sender;

@end
