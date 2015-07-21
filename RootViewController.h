@interface RootViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *_topicsTableView;
}
@property (retain, nonatomic) IBOutlet UITableView *topicsTableView;
@property (nonatomic, retain) NSMutableArray *topicsArray;
@end
