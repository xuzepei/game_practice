//
//  RCLevelResultView.h
//  BeatMole
//
//  Created by xuzepei on 6/14/13.
//
//

#import <UIKit/UIKit.h>

@protocol RCLevelResultViewDelegate <NSObject>

- (void)clickedReplayButton:(id)token;
- (void)clickedShareButton:(id)token;
- (void)clickedNextButton:(id)token;

@end

@interface RCLevelResultView : UIView

@property(nonatomic,retain)UIButton* replayButton;
@property(nonatomic,retain)UIButton* nextButton;
@property(nonatomic,retain)UIButton* shareButton;
@property(nonatomic,assign)id delegate;

- (void)updateContent:(int)levelIndex;

@end
