//
//  RCTipImageView.m
//  BeatMole
//
//  Created by xuzepei on 9/13/13.
//
//

#import "RCTipImageView.h"

@implementation RCTipImageView
@synthesize _image;


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(_image)
		[_image drawInRect: self.bounds];
}

- (void)dealloc
{
	[_image release];
    [super dealloc];
}

- (void)updateContent:(UIImage*)image
{
	self._image = image;
	[self setNeedsDisplay];
}

@end
