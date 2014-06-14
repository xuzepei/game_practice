//
//  RCTipView.h
//
//  Created by xuzepei on 9/13/11.
//

#import <UIKit/UIKit.h>

@interface RCTipView : UIView<UIScrollViewDelegate> {
	
}

@property(nonatomic,retain)UIScrollView* _scrollView;
@property(nonatomic,retain)UIPageControl* _pageControl;
@property(nonatomic,retain)NSArray* _imageNameArray;
@property(nonatomic,assign)BOOL _hidenWhenEnd;

- (void)initScrollView:(NSArray*)imageNameArray;

@end
