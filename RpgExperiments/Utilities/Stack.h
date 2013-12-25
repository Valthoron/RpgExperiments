//
//  DiceNotationTermStack.h
//  RpgExperimentsConsole
//
//  Created by Serdar Üşenmez on 21.04.2013.
//  Copyright (c) 2013 Serdar Üşenmez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject
{
	NSMutableArray* stack;
}

@property (nonatomic, readonly) id topObject;
@property (nonatomic, readonly) NSUInteger size;
@property (nonatomic, readonly) BOOL isEmpty;

- (void)push:(id)object;
- (id)pop;

@end
