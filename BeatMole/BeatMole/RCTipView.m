//
//  RCTipView.m
//
//  Created by xuzepei on 9/13/11.
//

#import "RCTipView.h"
#import "RCTool.h"
#import "RCTipImageView.h"

#define TIP_FRAME_WIDTH 320
#define TIP_FRAME_HEIGHT [WRTool getScreenSize].height  - 20
//#define MAX_PAGENUM 4

@implementation RCTipView
@synthesize _scrollView;
@synthesize _pageControl;
@synthesize _imageNameArray;
@synthesize _hidenWhenEnd;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
		//[self initScrollView];
        self._hidenWhenEnd = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[_scrollView release];
	[_pageControl release];
    self._imageNameArray = nil;
	
    [super dealloc];
}


- (void)initScrollView:(NSArray*)imageNameArray
{
    self._imageNameArray = imageNameArray;
    if(0 == [_imageNameArray count])
        return;
    
    CGFloat width = [RCTool getScreenSize].width;
    CGFloat height = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT;
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,width,height)];
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
	_scrollView.contentSize = CGSizeMake(width * [_imageNameArray count], height);
	[self addSubview: _scrollView];
    
    for(int i = 0; i < [_imageNameArray count]; i++)
    {
        UIImage *tipImage = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[_imageNameArray objectAtIndex:i] ofType:@"png"]] autorelease];
        
        RCTipImageView* subView = [[[RCTipImageView alloc] initWithFrame:CGRectMake(width * i,0,width,height)] autorelease];
        [subView updateContent:tipImage];
        [_scrollView addSubview:subView];
    }
	
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,height - 26,height,26)];
	_pageControl.backgroundColor = [UIColor clearColor];
	_pageControl.numberOfPages = [_imageNameArray count];
	_pageControl.currentPage = 0;
	[_pageControl addTarget:self 
					 action:@selector(changePage:) 
		   forControlEvents:UIControlEventValueChanged];
	[self addSubview: _pageControl];
    _pageControl.hidden = YES;
	
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    CGFloat width = [RCTool getScreenSize].width;
//    CGFloat height = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT;
    
    int page = floor((_scrollView.contentOffset.x - width / 2) / width) + 1;
    _pageControl.currentPage = page;

	if(page == [_imageNameArray count] - 1)
	{
        if(_hidenWhenEnd)
        {
            [UIView beginAnimations:@"hideTipView" 
                            context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:4.5];
            self.alpha = 0.0;
            [UIView commitAnimations];
        }
	}
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	if([animationID isEqualToString:@"hideTipView"] && finished)
	{
		[self removeFromSuperview];
	}
}

- (IBAction)changePage:(id)sender
{
	int page = _pageControl.currentPage;
	
	CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
	
}


@end
