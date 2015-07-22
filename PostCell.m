#import "PostCell.h"


@implementation PostCell
@synthesize contentLabel,avatarImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog(@"Initialized custom cell!!!");

        contentLabel = [[UILabel alloc]init];

        contentLabel.textAlignment = UITextAlignmentLeft;

        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;

        avatarImage = [[UIImageView alloc]init];

        [self.contentView addSubview:contentLabel];

        [self.contentView addSubview:avatarImage];

    }

    return self;

}

- (void)layoutSubviews {

    [super layoutSubviews];

    CGRect contentRect = self.contentView.bounds;

    CGFloat boundsX = contentRect.origin.x;
    float width = contentRect.size.width;
    float height = contentRect.size.height; 

    CGRect frame;

    frame= CGRectMake(boundsX+10, 5, 16, 16);

    avatarImage.frame = frame;

    frame= CGRectMake(boundsX + 10, 20, width - 38, height);

    contentLabel.frame = frame;


}

- (void)dealloc
{
    [avatarImage release];
    [contentLabel release];
    [super dealloc];
}
@end