#import "Topic.h"

@interface TopicViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *_topicTableView;
}

@property (nonatomic, retain) UITableView *topicTableView;
@property (nonatomic, retain) NSMutableArray *postsArray;
@property (nonatomic, retain) TopicObject *topic;
@property (nonatomic) NSInteger page;
@end
