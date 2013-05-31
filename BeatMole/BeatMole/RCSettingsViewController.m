//
//  RCSettingsViewController.m
//  BeatMole
//
//  Created by xuzepei on 5/29/13.
//
//

#import "RCSettingsViewController.h"
#import "RCTool.h"
#import "CUShareCenter.h"

@interface RCSettingsViewController ()

@end

@implementation RCSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.tableView)
        [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)] autorelease];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.tableView = nil;
}

- (void)clickedBackButton:(id)sender
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [DIRECTOR resume];

}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].height,[RCTool getScreenSize].width - NAVIGATION_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(0 == section)
    {
        return @"控制";
    }
    else if(1 == section)
    {
        return @"分享";
    }
    else if(2 == section)
    {
        return @"其他";
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(2 == section)
        return 40.0;
    
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    static NSString *cellId3 = @"cellId3";
    static NSString *cellId4 = @"cellId4";
    static NSString *cellId5 = @"cellId5";
    static NSString *cellId6 = @"cellId6";
    static NSString *cellId7 = @"cellId7";
    
    UITableViewCell *cell = nil;

    if(0 == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId0] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"音量";
            }
            
        }
        else if(1 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId1] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"腾讯微博";
            }
        }
    }
    else if(1 == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
            if (cell == nil)
            {
                cell = [[[RCBindCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId2] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"新浪微博";
            }
            
            RCBindCell* temp = (RCBindCell*)cell;
            temp.delegate = self;
            [temp updateContent:SHT_SINA];
            
        }
        else if(1 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
            if (cell == nil)
            {
                cell = [[[RCBindCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId3] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"腾讯微博";
            }
            
            RCBindCell* temp = (RCBindCell*)cell;
            temp.delegate = self;
            [temp updateContent:SHT_QQ];
        }
    }
    else if(2 == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId4];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId4] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"意见反馈";
            }
            
        }
        else if(1 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId5];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId5] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"关于";
            }
        }
    }

    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Bind

- (void)willChangeBindStatus:(BOOL)wantBind type:(SHARE_TYPE)type
{
    if(wantBind)
    {
        if(SHT_SINA == type)
        {
            CUShareCenter* sinaShare = [CUShareCenter sharedInstanceWithType:CUSHARE_SINA];
            
            if(NO == [sinaShare isBind])
            {
                [sinaShare bind:self];
            }
        }
        else
        {
            CUShareCenter* qqShare = [CUShareCenter sharedInstanceWithType:CUSHARE_QQ];
            
            if(NO == [qqShare isBind])
            {
                [qqShare bind:self];
            }
        }
    }
    else
    {
        if(SHT_SINA == type)
        {
            CUShareCenter* sinaShare = [CUShareCenter sharedInstanceWithType:CUSHARE_SINA];
            
            if([sinaShare isBind])
            {
                [sinaShare unBind];
            }
        }
        else
        {
            CUShareCenter* qqShare = [CUShareCenter sharedInstanceWithType:CUSHARE_QQ];
            
            if([qqShare isBind])
            {
                [qqShare unBind];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
