#import "RootViewController.h"

@interface OvercastApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
	UINavigationController *navigation;
}
@property (nonatomic, retain) UIWindow *window;
@end

@implementation OvercastApplication
@synthesize window = _window;
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];
	navigation = [[UINavigationController alloc] initWithRootViewController:_viewController];
	_window.rootViewController = navigation;
	// [_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
}

- (void)dealloc {
	[_viewController release];
	[_window release];
	[super dealloc];
}
@end

// vim:ft=objc
