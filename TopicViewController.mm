#import "TopicViewController.h"
#import "Post.m"
#import "PostCell.m"

@implementation TopicViewController
@synthesize postsArray;
@synthesize topicTableView;


- (void)viewDidLoad {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
	NSString *title = [NSString stringWithFormat:@"%@",[self.topic title]];
	[self setTitle:title];

	self.topicTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.topicTableView.dataSource = self;
	self.topicTableView.delegate = self;

	[self.view addSubview:self.topicTableView];

	[self refreshTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (tableView == self.topicTableView){
		return([self.postsArray count]);
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = @"Cell";

	PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	cell.contentLabel.numberOfLines = 0;
	cell.contentLabel.lineBreakMode = UILineBreakModeWordWrap;

	PostObject *currentPost = [self.postsArray objectAtIndex:indexPath.row];
	NSString *text = [currentPost text];

	NSError *error;
	NSAttributedString *formatted = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:&error];
	
	cell.contentLabel.attributedText = formatted;
	cell.avatarImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://crafatar.com/avatars/Jake_0?size=16"]]];
	return(cell);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UIFont * font = [UIFont systemFontOfSize:17.0f];
	PostObject *currentPost = [self.postsArray objectAtIndex:indexPath.row];
	NSString *text = [currentPost text];
	NSError *error;
	NSAttributedString *formatted = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:&error];
	CGFloat height = [formatted boundingRectWithSize:CGSizeMake(self.topicTableView.frame.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size.height;

	return height;
}

-(void)refreshTable {
	NSLog(@"Refreshing!");
	self.postsArray = nil;
	self.postsArray = [[NSMutableArray alloc] init];
	NSString *reqUrl = [NSString stringWithFormat:@"https://agile-tor-8712.herokuapp.com/forums/topics/%@",[self.topic topicId]];
	NSLog(@"%@", reqUrl);
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
		returningResponse:&response
		error:&error];


	if (error == nil and data) {
		NSLog(@"Here yo");
		NSError *err = nil;
		id object = [NSJSONSerialization
			JSONObjectWithData:data
			options:0
			error:&err];

		if ([object isKindOfClass:[NSDictionary class]]) {
			NSLog(@"INDEED");
			NSDictionary *results = object;
			NSArray *dataArray = [results valueForKeyPath:@"data.posts"];

			for (NSDictionary *eachPost in dataArray) {
				PostObject *post = [[PostObject alloc] initJSON:eachPost];
				[self.postsArray addObject:post];
			}
			[self.topicTableView reloadData];
		} else {

		}
	}
}

@end
