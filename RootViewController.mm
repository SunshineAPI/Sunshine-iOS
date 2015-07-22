#import "RootViewController.h"
#import "TopicViewController.h"
#import "Topic.m"

@implementation RootViewController
@synthesize topicsArray;
@synthesize topicsTableView;
@synthesize refreshControl;
@synthesize page;

- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setTitle:@"What's New?"];


	self.topicsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.topicsTableView.dataSource = self;
	self.topicsTableView.delegate = self;

	self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.page = 1;
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

	[self.view addSubview:self.topicsTableView];
	[self.topicsTableView addSubview:self.refreshControl];

	[self refreshTable];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      TopicObject *currentTopic = [self.topicsArray objectAtIndex:indexPath.row];
      TopicViewController *topicController = [TopicViewController alloc];
      topicController.topic = currentTopic;
      [self.navigationController pushViewController:topicController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (tableView == self.topicsTableView){
		return([self.topicsArray count]);
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	TopicObject *currentTopic = [self.topicsArray objectAtIndex:indexPath.row];
	NSString *title = [currentTopic title];
	NSString *author = [currentTopic author];
	cell.textLabel.text = title;
	NSString *crafatar = [NSString stringWithFormat:@"https://crafatar.com/avatars/%@?size=32", author];  
	cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:crafatar]]];
	return(cell);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

    if (maximumOffset - currentOffset <= -40) {
    	self.page += 1;
        [self refreshTable];
    }
}

-(void)refreshTable {
	if (self.page == 1 or self.refreshControl.isRefreshing) {
		self.topicsArray = nil;
		self.topicsArray = [[NSMutableArray alloc] init];
	}
	NSString *apiCall = [NSString stringWithFormat:@"https://agile-tor-8712.herokuapp.com/forums/new?page=%d", self.page];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:apiCall]];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
		returningResponse:&response
		error:&error];


	if (error == nil and data) {
		NSError *err = nil;
		id object = [NSJSONSerialization
			JSONObjectWithData:data
			options:0
			error:&err];

		if ([object isKindOfClass:[NSDictionary class]]) {
			NSDictionary *results = object;
			NSArray *dataArray = [results objectForKey:@"data"];

			for (NSDictionary *eachTopic in dataArray) {
				TopicObject *topic = [[TopicObject alloc] initJSON:eachTopic];
				[self.topicsArray addObject:topic];
			}
			[self.topicsTableView reloadData];
			[self.refreshControl endRefreshing];
		} else {

		}
	}
}

@end
