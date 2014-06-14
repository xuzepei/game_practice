//
//  RCHelpViewController.m
//  BeatMole
//
//  Created by xuzepei on 9/13/13.
//
//

#import "RCHelpViewController.h"
#import "RCTipView.h"
#import "RCTool.h"

@interface RCHelpViewController ()

@end

@implementation RCHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    RCTipView* tipView = [[[RCTipView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[WRTool getScreenSize].height - STATUS_BAR_HEIGHT)] autorelease];
    tipView._hidenWhenEnd = NO;
    [tipView initScrollView:[NSArray arrayWithObjects:
                             [WRTool isIphone5]?@"tip0-568h@2x":@"tip0",
                             [WRTool isIphone5]?@"tip1-568h@2x":@"tip1",nil]];
    
    [self.view addSubview: tipView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
