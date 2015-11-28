#import "OvercastWebViewController.h"
#import <UIKit/UIKit.h>

@implementation OvercastWebViewController
-(id)initWithURL:(NSURL*)url andDelegate:(id<UIWebViewDelegate>)del {
  self = [super init];
  if (self) {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    if (del) {
      webView.delegate = del;
    }

    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
  }
  return self;
}
@end