#import "RootViewController.h"
#import "Topic.m"

@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
	topicsArray = [[NSMutableArray alloc] init];

	NSLog(@"CALLED");
}

- (void)viewDidLoad {
	NSLog(@"CALLED KOSDVD");
	[super viewDidLoad];

	topicsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	topicsTableView.dataSource = self;
	topicsTableView.delegate = self;

	[self.view addSubview:topicsTableView];

	[self refreshTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (tableView == topicsTableView){
		NSLog(@"CALLING ROWS COUNT");
		NSLog(@"FINAL COUNT: %d",[topicsArray count]);
		return([topicsArray count]);
	}
	NSLog(@"NOTHING WATF");
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)dealloc{


	NSLog(@"Deallocated!!!!!");

	[super dealloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	if (cell == nil) {
		NSLog(@"NOT ABLE TO REUSE CELL");
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
	} else {
		NSLog(@"REUSING CELL!!!");
	}


	NSLog(@"CONFIGUING CELL!!");
	TopicObject *currentTopic = [topicsArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [currentTopic topicId];  
	return(cell);
}

-(void)refreshTable {
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
			NSString *dataString = [dataArray description];
			NSLog(@"%@", dataString);

			for (NSDictionary *eachTopic in dataArray) {
				TopicObject *topic = [[TopicObject alloc] initJSON:eachTopic];
				[topicsArray addObject:topic];
				NSLog(@"%@", [topic topicId]);
			}
			NSLog(@"ARRA COUNT: %d",[topicsArray count]);
			[topicsTableView reloadData];
		} else {

		}
	}
}

@end
