@interface RootViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *_topicsTableView;
	UIRefreshControl *_refreshControl;
	UINavigationBar *navBar;
	NSInteger page;
}
@property (retain, nonatomic) IBOutlet UITableView *topicsTableView;
@property (retain, nonatomic) IBOutlet UIRefreshControl *refreshControl;
@property (nonatomic, retain) NSMutableArray *topicsArray;
@property (nonatomic, retain) NSMutableDictionary *cachedAvatars;
@property (nonatomic) NSInteger page;
@end
