#import "PostCell.h"


@implementation PostCell
@synthesize contentLabel,avatarImage;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {

        contentLabel = [[UILabel alloc]init];

        contentLabel.textAlignment = UITextAlignmentLeft;

        contentLabel.font = [UIFont systemFontOfSize:17];

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

    CGRect frame;

    frame= CGRectMake(boundsX+10 ,0, 300, 40);

    avatarImage.frame = frame;

    frame= CGRectMake(boundsX+70 ,5, 200, 25);

    contentLabel.frame = frame;


}

- (void)dealloc
{
    [avatarImage release];
    [contentLabel release];
    [super dealloc];
}
@end