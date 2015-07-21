#import "RootViewController.h"
#import "TopicViewController.h"
#import "Topic.m"

@implementation RootViewController
@synthesize topicsArray;
@synthesize topicsTableView;
@synthesize refreshControl;

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
	cell.textLabel.text = title;  
	return(cell);
}

-(void)refreshTable {
	self.topicsArray = nil;
	self.topicsArray = [[NSMutableArray alloc] init];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://agile-tor-8712.herokuapp.com/forums/new"]];
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
