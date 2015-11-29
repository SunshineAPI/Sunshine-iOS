#import "LinkHelper.h"
#import "Forums/TopicViewController.h"
#import "Forums/Topic.h"
#import "OvercastWebViewController.h"

@implementation LinkHelper
+(BOOL)openURL:(NSURL*)url {
  NSArray *components = [url pathComponents];


  UITabBarController *tabBar = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
  UINavigationController *forumsController = tabBar.viewControllers[0];


  NSLog(@"COMP %@", components);

  if ([components[1] isEqualToString:@"forums"]) {
    if ([components[2] isEqualToString:@"topics"]) {
      NSString *topicId = components[3];
      if (topicId) {
        TopicViewController *viewController = [[TopicViewController alloc] init];
        TopicObject *topic = [[TopicObject alloc] init];
        topic.topicId = topicId;
        viewController.topic = topic;
        [forumsController pushViewController:viewController animated:YES];
      }
    }
  } else {
    OvercastWebViewController *webController = [[OvercastWebViewController alloc] initWithURL:url andDelegate:nil];
    [forumsController pushViewController:webController animated:YES];
  }

  return YES;

}
@end