#import "CategorySelectionDelegate.h"

@interface ForumsViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate, CategorySelectionDelegate> {
	UITableView *_topicsTableView;
	UIRefreshControl *_refreshControl;
	UINavigationBar *navBar;
	NSInteger page;
  NSString *category;
}

@property (retain, nonatomic) UITableView *topicsTableView;
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, retain) NSMutableArray *topicsArray;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSString *category;
@end
