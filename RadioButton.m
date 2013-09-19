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
	NSMutableArray* _otherButtons;
}
@end

@implementation RadioButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) awakeFromNib
{
	[self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

-(void) onTouchUpInside
{
	[self setRadioSelected:YES];
}

-(void) setOtherButtons:(NSArray *)buttons
{
	[_otherButtons removeAllObjects];
	if(!_otherButtons) {
		_otherButtons = [[NSMutableArray alloc] initWithCapacity:[buttons count]];
	}
	for(id obj in buttons) {
		[_otherButtons addObject:[NSValue valueWithNonretainedObject:obj]];
	}
}

-(NSArray*) otherButtons
{
	if(_otherButtons) {
		NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:[_otherButtons count]];
		for(NSValue* v in _otherButtons) {
			[buttons addObject:[v nonretainedObjectValue]];
		}
		return buttons;
	}
	return nil;
}

-(RadioButton*) selectedRadioButton
{
	if([self isSelected]) {
		return self;
	} else {
		for(NSValue* v in _otherButtons) {
			RadioButton* rb = [v nonretainedObjectValue];
			if([rb isSelected]) {
				return rb;
			}
		}
	}
	return nil;
}

-(void) setRadioSelected:(BOOL)selected
{
	self.selected = selected;
	for(NSValue* v in _otherButtons) {
		[[v nonretainedObjectValue] setSelected:!selected];
		selected = YES;
	}
}

-(void) selectRadioWithTag:(NSInteger)tag
{
	if(self.tag == tag) {
		[self setRadioSelected:YES];
	} else {
		for(NSValue* v in _otherButtons) {
			RadioButton* rb = [v nonretainedObjectValue];
			if(rb.tag == tag) {
				[rb setRadioSelected:YES];
				break;
			}
		}
	}
}

-(void) unbindOutlets
{
	NSArray* buttons = _otherButtons;
	_otherButtons = nil;
	for(NSValue* v in buttons) {
		[[v nonretainedObjectValue] unbindOutlets];
	}
}

- (void)dealloc
{
	[self unbindOutlets];
}


@end
