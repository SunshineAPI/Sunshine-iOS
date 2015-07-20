#import "RootViewController.h"
#import "Topic.m"

@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
	self.topicsArray = [[[NSMutableArray alloc] init] retain];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.topicsTableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] retain];
	self.topicsTableView.dataSource = self;
	self.topicsTableView.delegate = self;

	[self.view addSubview:self.topicsTableView];

	[self refreshTable];
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
	//NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d",indexPath.section,indexPath.row];
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	//if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	//}

	NSLog(@"CONFIGUING CELL!!");
	TopicObject *currentTopic = [self.topicsArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [currentTopic title];  
	return(cell);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// TopicObject *currentTopic = [topicsArray objectAtIndex:indexPath.row];
	// NSString *topicLink = [NSString stringWithFormat:@"https://oc.tc/forums/topics/%@", [currentTopic topicId]];
	// NSLog(@"%@", topicLink);
	// [[UIApplication sharedApplication] openURL:[NSURL URLWithString:topicLink]];
	// [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];

	// UIAlertView*topicAlert = [[UIAlertView alloc] initWithTitle:@"Clicked Topic" message:[currentTopic topicId] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	// [topicAlert show];
	// [topicAlert release];
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

			for (NSDictionary *eachTopic in dataArray) {
				TopicObject *topic = [[TopicObject alloc] initJSON:eachTopic];
				[self.topicsArray addObject:topic];
				NSLog(@"%@", [topic topicId]);
			}
			NSLog(@"ARRA COUNT: %d",[self.topicsArray count]);
			[self.topicsTableView reloadData];
		} else {

		}
	}
}

@end
