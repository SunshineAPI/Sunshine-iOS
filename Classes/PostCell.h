#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell
  @property (strong, nonatomic) IBOutlet UILabel *authorLabel;
  @property (strong, nonatomic) IBOutlet UITextView *bodyView;
  @property (strong, nonatomic) IBOutlet UIImageView *avatarView;
  @property (nonatomic, assign) BOOL didSetupConstraints;
@end