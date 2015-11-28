#import "ForumsViewController.h"

@interface OvercastApplication : UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	UITabBarController *_tabBarController;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@end

@implementation OvercastApplication
@synthesize window, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.tabBarController = [[UITabBarController alloc] init];


	ForumsViewController *forumsController = [[ForumsViewController alloc] init];
	UINavigationController *forumsNav = [[UINavigationController alloc] initWithRootViewController:forumsController];
	// forumsNav.tabBarItem.image = [UIImage imageNamed:@"TabForums.png"];


	NSArray *controllers = [NSArray arrayWithObjects:forumsNav, nil];
	self.tabBarController.viewControllers = controllers;

	self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = self.tabBarController;

	[self.window makeKeyAndVisible];
}

@end
