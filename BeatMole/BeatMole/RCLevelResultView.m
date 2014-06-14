//
//  RCLevelResultView.m
//  BeatMole
//
//  Created by xuzepei on 6/14/13.
//
//

#import "RCLevelResultView.h"
#import "RCLevel.h"

@implementation RCLevelResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.replayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.replayButton.frame = CGRectMake(0,0,40,40);
        [self.replayButton addTarget:self
                             action:@selector(clickedReplayButton:)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.replayButton];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.shareButton.frame = CGRectMake(60,0,40,40);
        [self.shareButton addTarget:self
                             action:@selector(clickedShareButton:)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shareButton];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.nextButton.frame = CGRectMake(120,0,40,40);
        [self.nextButton addTarget:self
                              action:@selector(clickedNextButton:)forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton setEnabled:NO];
        [self addSubview:self.nextButton];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.replayButton = nil;
    self.nextButton = nil;
    self.shareButton = nil;
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateContent:(int)levelIndex
{
    NSDictionary* result = [RCLevel getLevelResultByIndex:levelIndex];
    int star = [[result objectForKey:@"star"] intValue];
    if(star > 0)
    {
        [self.nextButton setEnabled:YES];
    }
}

- (void)clickedReplayButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedReplayButton:)])
    {
        [_delegate clickedReplayButton:nil];
    }
}

- (void)clickedShareButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedShareButton:)])
    {
        [_delegate clickedShareButton:nil];
    }
}

- (void)clickedNextButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedNextButton:)])
    {
        [_delegate clickedNextButton:nil];
    }
}

@end
