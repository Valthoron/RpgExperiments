//
//  MapGenerateDialogController.m
//  RpgExperiments
//
//  Created by Serdar Üşenmez on 6.12.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import "MapGenerateDialogController.h"
#import "Builder.h"
#import "CaveBuilder.h"
#import "DungeonBuilder.h"

@implementation MapGenerateDialogController

- (id)init
{
    self = [super initWithWindowNibName:@"MapGenerateDialog"];
	
    if (self)
	{
		_builders = [NSMutableArray arrayWithObjects:
					 [[CaveBuilder alloc] init],
					 [[DungeonBuilder alloc] init],
					 nil];
		_parameters = [[NSMutableDictionary alloc] init];
		
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* documentsPath = [paths objectAtIndex:0];
		recordFilePath = [documentsPath stringByAppendingPathComponent:@"RpgExperiments.MapGenerateParameters.plist"];
    }
	
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	
	NSDictionary* record = [NSDictionary dictionaryWithContentsOfFile:recordFilePath];
	
	if (record != nil)
	{
		[_buildersPopupButton selectItemWithTitle:[record objectForKey:@"builder"]];
		[_widthTextField setIntegerValue:[[record objectForKey:@"width"] integerValue]];
		[_heightTextField setIntegerValue:[[record objectForKey:@"height"] integerValue]];
		
		[self willChangeValueForKey:@"parameters"];
		[_parameters addEntriesFromDictionary:[record objectForKey:@"configuration"]];
		[self didChangeValueForKey:@"parameters"];
	}
	
	[_generateButton setKeyEquivalent:@"\r"];
}

- (IBAction)addParameter:(id)sender
{
	[_parametersController addObject:[_parametersController newObject]];
}

- (IBAction)removeParameter:(id)sender
{
	if (_parametersTableView.selectedRow < 0)
		return;
	
	[_parametersController removeObjectAtArrangedObjectIndex:_parametersController.selectionIndex];
}

- (IBAction)loadDefaultParameters:(id)sender
{
	Builder* builder = [_builders objectAtIndex:_buildersPopupButton.indexOfSelectedItem];
	
	[self willChangeValueForKey:@"parameters"];
	[_parameters removeAllObjects];
	[_parameters addEntriesFromDictionary:[builder defaultConfiguration]];
	[self didChangeValueForKey:@"parameters"];
}

- (IBAction)generate:(id)sender
{
	if (_buildersPopupButton.indexOfSelectedItem < 0)
		return;
	
	_result = [NSDictionary dictionaryWithObjectsAndKeys:
			   [_builders objectAtIndex:_buildersPopupButton.indexOfSelectedItem], @"builder",
			   [NSNumber numberWithUnsignedInteger:_widthTextField.integerValue], @"width",
			   [NSNumber numberWithUnsignedInteger:_heightTextField.integerValue], @"height",
			   [NSDictionary dictionaryWithDictionary:_parameters], @"configuration",
			   nil];
	
	NSDictionary* record = [NSDictionary dictionaryWithObjectsAndKeys:
			   _buildersPopupButton.selectedItem.title, @"builder",
			   _widthTextField.stringValue, @"width",
			   _heightTextField.stringValue, @"height",
			   [_parameters copy], @"configuration",
			   nil];
	
	[record writeToFile:recordFilePath atomically:YES];
	
	[NSApp endSheet:self.window];
}

- (IBAction)cancel:(id)sender
{
	_result = nil;
	[NSApp endSheet:self.window];
}

@end
