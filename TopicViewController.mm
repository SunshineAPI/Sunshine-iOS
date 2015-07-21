#import "TopicViewController.h"

@implementation TopicViewController


- (void)viewDidLoad {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
	NSString *title = [NSString stringWithFormat:@"%@",[self.topic title]];
	[self setTitle:title];
}

@end
