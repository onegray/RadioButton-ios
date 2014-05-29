//
//  RadioButton.m
//
//  Created by Sergey Nikitenko on 3/5/13.
//  Copyright 2013 Sergey Nikitenko. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RadioButton.h"

@interface RadioButton()
{
	NSMutableArray* _sharedLinks;
}
@end

@implementation RadioButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		if(![[self allTargets] containsObject:self]) {
			[super addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		}
    }
    return self;
}

-(void) awakeFromNib
{
	if(![[self allTargets] containsObject:self]) {
		[super addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
	}
}

-(void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
	// 'self' should be the first target
	if(![[self allTargets] containsObject:self]) {
		[super addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
	}
	[super addTarget:target action:action forControlEvents:controlEvents];
}

-(void) onTouchUpInside
{
	[self setSelected:YES distinct:YES sendControlEvent:YES];
}

-(void) setGroupButtons:(NSArray *)buttons
{
	if(!_sharedLinks) {
		for(RadioButton* rb in buttons) {
			if(rb->_sharedLinks) {
				_sharedLinks = rb->_sharedLinks;
				break;
			}
		}
		if(!_sharedLinks) {
			_sharedLinks = [[NSMutableArray alloc] initWithCapacity:[buttons count]+1];
		}
	}

	BOOL (^btnExistsInList)(NSArray*, RadioButton*) = ^(NSArray* list, RadioButton* rb){
		for(NSValue* v in list) {
			if([v nonretainedObjectValue]==rb) {
				return YES;
			}
		}
		return NO;
	};

	if(!btnExistsInList(_sharedLinks, self)) {
		[_sharedLinks addObject:[NSValue valueWithNonretainedObject:self]];
	}

	for(RadioButton* rb in buttons) {
		if(rb->_sharedLinks!=_sharedLinks) {
			if(!rb->_sharedLinks) {
				rb->_sharedLinks = _sharedLinks;
			} else {
				for(NSValue* v in rb->_sharedLinks) {
					RadioButton* vrb = [v nonretainedObjectValue];
					if(!btnExistsInList(_sharedLinks, vrb)) {
						[_sharedLinks addObject:v];
						vrb->_sharedLinks = _sharedLinks;
					}
				}
			}
		}
		if(!btnExistsInList(_sharedLinks, rb)) {
			[_sharedLinks addObject:[NSValue valueWithNonretainedObject:rb]];
		}
	}
}

-(NSArray*) groupButtons
{
	if([_sharedLinks count]) {
		NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:[_sharedLinks count]];
		for(NSValue* v in _sharedLinks) {
			[buttons addObject:[v nonretainedObjectValue]];
		}
		return buttons;
	}
	return nil;
}

-(RadioButton*) selectedButton
{
	if([self isSelected]) {
		return self;
	} else {
		for(NSValue* v in _sharedLinks) {
			RadioButton* rb = [v nonretainedObjectValue];
			if([rb isSelected]) {
				return rb;
			}
		}
	}
	return nil;
}

-(void) setSelected:(BOOL)selected
{
	[self setSelected:selected distinct:YES sendControlEvent:NO];
}

-(void) setButtonSelected:(BOOL)selected sendControlEvent:(BOOL)sendControlEvent
{
	BOOL valueChanged = (self.selected != selected);
	[super setSelected:selected];
	if(valueChanged && sendControlEvent) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

-(void) setSelected:(BOOL)selected distinct:(BOOL)distinct sendControlEvent:(BOOL)sendControlEvent
{
	[self setButtonSelected:selected sendControlEvent:sendControlEvent];

	if( distinct && (selected || [_sharedLinks count]==2) )
	{
		selected = !selected;
		for(NSValue* v in _sharedLinks) {
			RadioButton* rb = [v nonretainedObjectValue];
			if(rb!=self) {
				[rb setButtonSelected:selected sendControlEvent:sendControlEvent];
			}
		}
	}
}

-(void) deselectAllButtons
{
	for(NSValue* v in _sharedLinks) {
		RadioButton* rb = [v nonretainedObjectValue];
		[rb setButtonSelected:NO sendControlEvent:NO];
	}
}

-(void) setSelectedWithTag:(NSInteger)tag
{
	if(self.tag == tag) {
		[self setSelected:YES distinct:YES sendControlEvent:NO];
	} else {
		for(NSValue* v in _sharedLinks) {
			RadioButton* rb = [v nonretainedObjectValue];
			if(rb.tag == tag) {
				[rb setSelected:YES distinct:YES sendControlEvent:NO];
				break;
			}
		}
	}
}

- (void)dealloc
{
	for(NSValue* v in _sharedLinks) {
		if([v nonretainedObjectValue]==self) {
			[_sharedLinks removeObjectIdenticalTo:v];
			break;
		}
	}
}


@end
