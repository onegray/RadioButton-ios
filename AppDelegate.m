//
//  AppDelegate.m
//  RadioButtonSample
//
//  Created by Sergey on 9/22/13.
//
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_window.rootViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
	[_window makeKeyAndVisible];
    return YES;
}

@end
