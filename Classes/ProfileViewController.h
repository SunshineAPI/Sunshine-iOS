@interface ProfileViewController : UIViewController <UISearchControllerDelegate, UISearchBarDelegate, UIWebViewDelegate>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIWebView *profileView;
@end