//
//  MapGenerateDialogController.h
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 6.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Builder.h"

@interface MapGenerateDialogController : NSWindowController
{
	NSString* recordFilePath;
}

@property (weak) IBOutlet NSTableView* parametersTableView;
@property (weak) IBOutlet NSPopUpButton* buildersPopupButton;
@property (weak) IBOutlet NSTextField* widthTextField;
@property (weak) IBOutlet NSTextField* heightTextField;
@property (nonatomic, strong) IBOutlet NSDictionaryController* parametersController;
@property (nonatomic, strong) NSMutableDictionary* parameters;
@property (nonatomic, strong) NSArray* builders;
@property (nonatomic) NSDictionary* result;

- (IBAction)generate:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addParameter:(id)sender;
- (IBAction)removeParameter:(id)sender;

@end
