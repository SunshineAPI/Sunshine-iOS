@interface OvercastWebViewController : UIViewController
@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, retain) id<UIWebViewDelegate> delegate;

-(id)initWithURL:(NSURL*)url andDelegate:(id<UIWebViewDelegate>)delegate;
@end