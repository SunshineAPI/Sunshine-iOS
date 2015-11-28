#import "../AFNetworking/AFNetworking.h"
#import "ProfileViewController.h"

@implementation ProfileViewController
@synthesize profileView, searchController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Profiles";
  }
  return self;
}

- (void)viewDidLoad {
  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];
  self.edgesForExtendedLayout = UIRectEdgeNone; 
  [super viewDidLoad];

  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.delegate = self;

  self.definesPresentationContext = YES;

  [self.searchController.searchBar sizeToFit];

  self.profileView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  CGRect frame = profileView.frame;
  profileView.frame = CGRectMake(frame.origin.x, self.searchController.searchBar.frame.size.height, frame.size.width, frame.size.height);
  self.profileView.scalesPageToFit = YES;
  self.profileView.delegate = self;
  [self.profileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://oc.tc/Jake_0"]]];

  [self.view addSubview:self.searchController.searchBar];
  [self.view addSubview:self.profileView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  NSString *player = searchBar.text;
  if (!player || [player isEqualToString:@""]) return;

  NSString *url = [NSString stringWithFormat:@"https://oc.tc/%@", player];

  [self.profileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed to Load"
   message:@"Failed to load the Overcast website."
   preferredStyle:UIAlertControllerStyleAlert];
 
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" 
    style:UIAlertActionStyleDefault
    handler:nil];
   
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview {
  NSCachedURLResponse *urlResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:webview.request];
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) urlResponse.response;
  NSInteger statusCode = httpResponse.statusCode;

  if (statusCode == 404) {
    [self.profileView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Player not Found"
      message:@"This player does not exist. Try again."
      preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" 
      style:UIAlertActionStyleDefault
      handler:nil];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

@end