@interface RootViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate> {
}
@property (nonatomic, retain) IBOutlet UITableView *topicsTableView;
@property (nonatomic, retain) NSMutableArray *topicsArray;
@end
