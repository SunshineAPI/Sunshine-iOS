#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell {
    UILabel *contentLabel;
    UIImageView *avatarImage;
}

@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UIImageView *avatarImage;
@end