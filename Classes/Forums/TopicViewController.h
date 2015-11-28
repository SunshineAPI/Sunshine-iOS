#import "Topic.h"

@interface TopicViewController: UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIWebViewDelegate> {
	UITableView *_topicTableView;
  UIRefreshControl *_refreshControl;
}

@property (nonatomic, retain) UITableView *topicTableView;
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, retain) NSMutableArray *postsArray;
@property (nonatomic, retain) TopicObject *topic;
@property (nonatomic) NSInteger page;
@end
