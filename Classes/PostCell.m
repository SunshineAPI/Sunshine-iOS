#import "PostCell.h"
#import "PureLayout/PureLayout.h"

#define kLabelHorizontalInsets 15.0f
#define kLabelVerticalInsets 10.0f

@implementation PostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      
    self.authorLabel = [UILabel newAutoLayoutView];
    [self.authorLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.authorLabel setNumberOfLines:1];

    self.avatarView = [UIImageView newAutoLayoutView];
    self.avatarView.frame = CGRectMake(0, 0, 64, 64);

    self.bodyView = [UITextView newAutoLayoutView];
    self.bodyView.textContainer.lineFragmentPadding = 0;
    self.bodyView.textContainerInset = UIEdgeInsetsZero;

    [self.contentView addSubview:self.bodyView];

    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.avatarView];      
  }
  
  return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.avatarView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];

    [self.avatarView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
    [self.avatarView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];

    // setup author
    // 
    [self.authorLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.avatarView withOffset:kLabelHorizontalInsets];
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.authorLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];

    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];

    // setup body

    [self.bodyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarView withOffset:kLabelVerticalInsets];
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.bodyView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.bodyView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
    [self.bodyView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.bodyView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
    
    self.didSetupConstraints = YES;
  }
    
  [super updateConstraints];
}

@end