//
//  RCTipImageView.h
//  BeatMole
//
//  Created by xuzepei on 9/13/13.
//
//

#import <UIKit/UIKit.h>

@interface RCTipImageView : UIView
{
	UIImage* _image;
}

@property(nonatomic,retain)UIImage* _image;

- (void)updateContent:(UIImage*)image;

@end
