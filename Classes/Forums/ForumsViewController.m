#import "ForumsViewController.h"
#import "TopicViewController.h"
#import "Topic.h"
#import "../AFNetworking/AFNetworking.h"
#import "../UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "ForumsHelper.h"
#import "CategoriesViewController.h"

@implementation ForumsViewController
@synthesize topicsArray, topicsTableView, refreshControl, page, category;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Forums";
  }
  return self;
}

- (void)viewDidLoad {
  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

	[super viewDidLoad];
	self.navigationItem.title = @"What's New?";

	self.topicsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.topicsTableView.dataSource = self;
	self.topicsTableView.delegate = self;
  self.topicsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.tintColor = [UIColor lightGrayColor];
  self.page = 1;
  [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

	[self.view addSubview:self.topicsTableView];
	[self.topicsTableView addSubview:self.refreshControl];

  UIBarButtonItem *categoriesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
    target:self
    action:@selector(openCategories:)];
  self.navigationItem.leftBarButtonItem = categoriesButton;


  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  if ([defaults objectForKey:@"forums_categories"]) {
    self.categories = [defaults objectForKey:@"forums_categories"];
  } else {
    [ForumsHelper getCategories:^void (NSArray *results) {
      NSMutableArray *temp = [results mutableCopy];
      [temp removeObjectAtIndex:0];

      self.categories = [temp copy];

      [defaults setObject:self.categories forKey:@"forums_categories"];
      [defaults synchronize];
    }];
  }


	[self refreshTable];
}

-(void)openCategories:(id)sender {
  CategoriesViewController *categorySelection = [[CategoriesViewController alloc] init];
  categorySelection.categories = self.categories;

  categorySelection.delegate = self;

  [self.navigationController pushViewController:categorySelection animated:YES];
}

-(void)didSelectCategory:(NSString*)categoryId withName:(NSString*)categoryName {
  if (categoryId && categoryName) {
    self.navigationItem.title = categoryName;
    self.category = categoryId;

    self.page = 1;

    [self refreshTable];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  TopicObject *currentTopic = [self.topicsArray objectAtIndex:indexPath.row];
  TopicViewController *topicController = [TopicViewController alloc];
  topicController.topic = currentTopic;
  
  [self.navigationController pushViewController:topicController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView != self.topicsTableView) return 0;
	return [self.topicsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	TopicObject *currentTopic = [self.topicsArray objectAtIndex:indexPath.row];
	NSString *title = [currentTopic title];
	NSString *author = [currentTopic author];
	cell.textLabel.text = title;

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://crafatar.com/avatars/%@?size=64&helm", author]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	__weak UITableViewCell *weakCell = cell;

	[cell.imageView setImageWithURLRequest:request
   	placeholderImage:nil
   	success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
      weakCell.imageView.image = image;
      [weakCell setNeedsLayout];
   } failure:nil];

	return cell;
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
  NSString *apiCall;
  if (self.category) {
    apiCall = [NSString stringWithFormat:@"https://sunshine-api.com/forums/%@?page=%d", self.category, (int) self.page];
  } else {
    apiCall = [NSString stringWithFormat:@"https://sunshine-api.com/forums/new?page=%d", (int) self.page];
  }

  if (self.page == 1 || self.refreshControl.isRefreshing) {
   self.topicsArray = nil;
   self.topicsArray = [[NSMutableArray alloc] init];
  }

  [self.refreshControl beginRefreshing];
  [self.topicsTableView reloadData];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager GET:apiCall
    parameters:nil
    success:^(NSURLSessionDataTask *task, id results) {
      NSArray *dataArray = [results objectForKey:@"data"];

      for (NSDictionary *eachTopic in dataArray) {
        TopicObject *topic = [[TopicObject alloc] initJSON:eachTopic];
        [self.topicsArray addObject:topic];
      }

      dispatch_async(dispatch_get_main_queue(), ^{
        [self.topicsTableView reloadData];
        [self.refreshControl endRefreshing];
      });
    }
    failure:nil];
}

@end
