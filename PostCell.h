#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell {
    UILabel *contentLabel;
    UILabel *authorLabel;
    UIImageView *avatarImage;
}

@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UIImageView *avatarImage;
@end