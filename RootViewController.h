@interface RootViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *_topicsTableView;
	UIRefreshControl *_refreshControl;
	UINavigationBar *navBar;
}
@property (retain, nonatomic) IBOutlet UITableView *topicsTableView;
@property (retain, nonatomic) IBOutlet UIRefreshControl *refrshControl;
@property (nonatomic, retain) NSMutableArray *topicsArray;
@end
