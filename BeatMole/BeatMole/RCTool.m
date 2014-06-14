//
//  RCTool.m
//  BeatMole
//
//  Created by xuzepei on 5/23/13.
//
//

#import "RCTool.h"
#import "RCMole.h"
#import "CCAnimation+Helper.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "AppDelegate.h"

@implementation RCTool

+ (NSString*)getUserDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)md5:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}

+ (NSString *)getIpAddress
{
	
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString*)base64forData:(NSData*)theData
{
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

+ (UIWindow*)frontWindow
{
	UIApplication *app = [UIApplication sharedApplication];
    NSArray* windows = [app windows];
    
    for(int i = [windows count] - 1; i >= 0; i--)
    {
        UIWindow *frontWindow = [windows objectAtIndex:i];
        //NSLog(@"window class:%@",[frontWindow class]);
        //        if(![frontWindow isKindOfClass:[MTStatusBarOverlay class]])
        return frontWindow;
    }
    
	return nil;
}

#pragma mark - 兼容iOS6和iPhone5

+ (CGSize)getScreenSize
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGRect)getScreenRect
{
    return [[UIScreen mainScreen] bounds];
}

+ (BOOL)isIphone5
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if(568 == size.height)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isIpad
{
	UIDevice* device = [UIDevice currentDevice];
	if(device.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
	{
		return NO;
	}
	else if(device.userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	
	return NO;
}

+ (RCMole*)getMoleByTeamType:(TEAM_TYPE)teamType moleType:(NSString*)moleType
{
    if(0 == [moleType length])
        return nil;
    
    NSString* name = [NSString stringWithFormat:@"mole_config_team_%d",teamType];
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    for(NSDictionary* dict in array)
    {
        NSString* type = [dict objectForKey:@"type"];
        if(NO == [moleType isEqualToString:type])
            continue;
        
        NSString* id = [dict objectForKey:@"id"];
        NSString* name = [dict objectForKey:@"name"];
        NSString* hp = [dict objectForKey:@"hp"];
        NSString* showTime = [dict objectForKey:@"showTime"];
        NSString* coin = [dict objectForKey:@"coin"];
        NSString* penalty = [dict objectForKey:@"penalty"];
        NSString* teamType = [dict objectForKey:@"teamType"];
        NSString* speed = [dict objectForKey:@"speed"];
        
        if([teamType length] && [type length])
        {
            NSString* frameName = [NSString stringWithFormat:@"mole_%@_0.png",id];
            
            NSLog(@"mole_frame_name:%@",frameName);
            RCMole* mole = [RCMole spriteWithSpriteFrameName:frameName];
            mole.id = [id intValue];
            mole.showingHoleIndex = -1;
            mole.anchorPoint = ccp(0.5,0.5);
            mole.name = name;
            mole.imageName = frameName;
            mole.type = [type intValue];
            mole.hp = [hp intValue];
            mole.showTime = [showTime intValue];
            mole.coin = [coin intValue];
            mole.penalty = [penalty intValue];
            mole.teamType = [teamType intValue];
            mole.speed = [speed intValue];
            [mole addHPBar];
            
            
            NSArray* indexArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"9",nil];
            frameName = [NSString stringWithFormat:@"mole_%d_",mole.id];
            mole.moveUpAnimation = [CCAnimation animationWithFrame:frameName indexArray:indexArray delay:0.1];
            
            indexArray = [NSArray arrayWithObjects:@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"0",nil];
            frameName = [NSString stringWithFormat:@"mole_%d_",mole.id];
            mole.moveDownAnimation = [CCAnimation animationWithFrame:frameName indexArray:indexArray delay:0.1];
            
            indexArray = [NSArray arrayWithObjects:@"0",@"1",@"2",nil];
            frameName = [NSString stringWithFormat:@"mole_beat_%d_",mole.id];
            mole.beatMoveDownAnimation = [CCAnimation animationWithFrame:frameName indexArray:indexArray delay:0.1];
            
            indexArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"4",nil];
            frameName = [NSString stringWithFormat:@"mole_dead_%d_",mole.id];
            mole.deadDownAnimation = [CCAnimation animationWithFrame:frameName indexArray:indexArray delay:0.1];

            return mole;
        }
    }
    
    return nil;
}

+ (RCNavigationController*)getRootNavigationController
{
    AppController* appDelegate =(AppController*)[UIApplication sharedApplication].delegate;
    return appDelegate.navigationController;
}

@end
