#import "TopicViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "PostImageAttachment.h"
#import "AFNetworking/AFNetworking.h"
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"

@implementation TopicViewController 
@synthesize postsArray;
@synthesize topicTableView;
@synthesize cachedAvatars;

- (void) viewDidLoad {
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor whiteColor];
	NSString * title = [NSString stringWithFormat: @"%@", [self.topic title]];
	[self setTitle: title];

	self.topicTableView = [[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain];
	self.topicTableView.dataSource = self;
	self.topicTableView.delegate = self;

	self.cachedAvatars = [
		[NSMutableDictionary alloc] init
	];

	[self.view addSubview: self.topicTableView];

	[self refreshTable];
}

- (NSInteger)tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView == self.topicTableView) {
		return ([self.postsArray count]);
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView * ) tableView {
	return 1;
}

- (UITableViewCell * )tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	NSString * CellIdentifier = @"Cell";

	PostCell * cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];

	if (cell == nil) {
		cell = [[PostCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
	}

	PostObject * currentPost = [self.postsArray objectAtIndex: indexPath.row];
	NSString * text = [currentPost text];
	NSString * author = [currentPost author];
	NSError * error;
	NSMutableAttributedString * formatted = [
		[NSMutableAttributedString alloc] initWithData: [text dataUsingEncoding: NSUTF8StringEncoding] options: @{
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
		}
		documentAttributes: nil error: & error
	];

	[formatted enumerateAttribute: NSAttachmentAttributeName inRange: NSMakeRange(0, formatted.length) options: 0 usingBlock: ^ (id value, NSRange range, BOOL * stop) {
		if (value) {
			NSTextAttachment *attachment = (NSTextAttachment *)value;
			PostImageAttachment* postAttach = [PostImageAttachment new];
			postAttach.image = attachment.image;
			
			[formatted appendAttributedString:[NSAttributedString attributedStringWithAttachment:postAttach]];

		}
	}];

	cell.contentLabel.attributedText = formatted;
	cell.authorLabel.text = author;

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://crafatar.com/avatars/%@?size=32&helm", author]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	__weak UITableViewCell *weakCell = cell;

	[cell.imageView setImageWithURLRequest:request
   	placeholderImage:nil
   	success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
      weakCell.imageView.image = image;
      [weakCell setNeedsLayout];
   } failure:nil];

	return (cell);
}

- (CGFloat) tableView: (UITableView * ) tableView heightForRowAtIndexPath: (NSIndexPath * ) indexPath {
	PostObject * currentPost = [self.postsArray objectAtIndex: indexPath.row];
	NSString * text = [currentPost text];
	NSError * error;
	NSAttributedString * formatted = [
		[NSAttributedString alloc] initWithData: [text dataUsingEncoding: NSUTF8StringEncoding] options: @{
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
		}
		documentAttributes: nil error: & error
	];
	CGFloat height = [formatted boundingRectWithSize: CGSizeMake(self.topicTableView.frame.size.width - 10, CGFLOAT_MAX) options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context: nil].size.height;

	return height + 25;
}

- (void) refreshTable {
	self.postsArray = nil;
	self.postsArray = [
		[NSMutableArray alloc] init
	];
	NSString * reqUrl = [NSString stringWithFormat: @"https://sunshine-api.com/forums/topics/%@", [self.topic topicId]];
	NSURLRequest * urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: reqUrl]];
	NSURLResponse * response = nil;
	NSError * error = nil;
	NSData * data = [NSURLConnection sendSynchronousRequest: urlRequest
		returningResponse: & response
		error: & error
	];


	if (error == nil && data) {
		NSError * err = nil;
		id object = [NSJSONSerialization
			JSONObjectWithData: data
			options: 0
			error: & err
		];

		if ([object isKindOfClass: [NSDictionary class]]) {
			NSDictionary * results = object;
			NSArray * dataArray = [results valueForKeyPath: @"data.posts"];

			for (NSDictionary * eachPost in dataArray) {
				PostObject * post = [
					[PostObject alloc] initJSON: eachPost
				];
				[self.postsArray addObject: post];
			}
			[self.topicTableView reloadData];
		}
	}
}

@end