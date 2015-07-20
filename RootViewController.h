@interface RootViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *topicsTableView;
	NSMutableArray *topicsArray;
	UILabel *jsonLabel;
}
@end
