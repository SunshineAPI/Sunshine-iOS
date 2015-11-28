#import "TopicViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "PostImageAttachment.h"
#import "AFNetworking/AFNetworking.h"
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"

static NSString *CellIdentifier = @"Cell";

@implementation TopicViewController 
@synthesize postsArray, topicTableView;

- (void) viewDidLoad {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = self.topic.title;
	
	self.topicTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.topicTableView.dataSource = self;
	self.topicTableView.delegate = self;

  self.topicTableView.estimatedRowHeight = 300;
  self.topicTableView.rowHeight = UITableViewAutomaticDimension;
  self.topicTableView.allowsSelection = NO;
  [self.topicTableView registerClass:[PostCell class] forCellReuseIdentifier:CellIdentifier];

	[self.view addSubview:self.topicTableView];

	self.page = 1;
	[self refreshTable];
}

- (NSInteger)tableView:(UITableView * )tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView != self.topicTableView) return 0;
	return [self.postsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView * )tableView {
	return 1;
}

- (UITableViewCell * )tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	PostCell *cell = [self.topicTableView dequeueReusableCellWithIdentifier:CellIdentifier];

	PostObject *currentPost = [self.postsArray objectAtIndex: indexPath.row];
	NSString *text = [currentPost text];
	NSString *author = [currentPost author];
	NSError *error;
	NSMutableAttributedString * formatted = [
		[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:@{
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
		}
		documentAttributes:nil error:&error];

	[formatted enumerateAttribute: NSAttachmentAttributeName inRange: NSMakeRange(0, formatted.length) options: 0 usingBlock: ^ (id value, NSRange range, BOOL * stop) {
		if (value) {
			NSTextAttachment *attachment = (NSTextAttachment*) value;
			PostImageAttachment* postAttach = [PostImageAttachment new];
			postAttach.image = attachment.image;
			
			[formatted appendAttributedString:[NSAttributedString attributedStringWithAttachment:postAttach]];

		}
	}];

  cell.bodyView.scrollEnabled = NO;
  cell.bodyView.editable = NO;
	cell.bodyView.attributedText = formatted;
	cell.authorLabel.text = author;

  CGFloat fixedWidth = cell.bodyView.bounds.size.width - 30;
    CGSize newSize = [cell.bodyView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
   NSLog(@"width = %f, height = %f", newSize.width, newSize.height);
    CGRect newFrame = cell.bodyView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    cell.bodyView.frame = newFrame;

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://crafatar.com/avatars/%@?size=64&helm", author]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	__weak PostCell *weakCell = cell;

	[cell.avatarView setImageWithURLRequest:request
   	placeholderImage:nil
   	success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
      weakCell.avatarView.image = image;
      [weakCell setNeedsLayout];
   } failure:nil];

  [cell setNeedsUpdateConstraints];
  [cell updateConstraintsIfNeeded];

	return cell;
}

- (CGFloat) tableView: (UITableView * ) tableView heightForRowAtIndexPath: (NSIndexPath * ) indexPath {
	PostObject *currentPost = [self.postsArray objectAtIndex: indexPath.row];
	NSString *text = [currentPost text];
	NSError *error;
	NSAttributedString *formatted = [
		[NSAttributedString alloc] initWithData: [text dataUsingEncoding:NSUTF8StringEncoding] options:@{
			NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType
		}
		documentAttributes:nil error:&error
	];
	CGFloat height = [formatted boundingRectWithSize:CGSizeMake(self.topicTableView.frame.size.width - 10, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context: nil].size.height;

	return height + 25;
}

- (void)refreshTable {
	NSString *apiCall = [NSString stringWithFormat: @"https://sunshine-api.com/forums/topics/%@", [self.topic topicId]];

  if (self.page == 1) {
   self.postsArray = nil;
   self.postsArray = [[NSMutableArray alloc] init];
  }

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager GET:apiCall
    parameters:nil
    success:^(NSURLSessionDataTask *task, id results) {
			NSArray *dataArray = [results valueForKeyPath:@"data.posts"];
			for (NSDictionary *postData in dataArray) {
				PostObject *post = [[PostObject alloc] initJSON:postData];
				[self.postsArray addObject:post];
			}

      dispatch_async(dispatch_get_main_queue(), ^{
        [self.topicTableView reloadData];
      });
    }
    failure:nil];
}

@end