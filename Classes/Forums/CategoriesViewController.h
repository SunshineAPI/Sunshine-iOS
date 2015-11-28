#import <UIKit/UIKit.h>
#import "CategorySelectionDelegate.h"

@interface CategoriesViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) UITableView *categoriesTable;
@property (nonatomic, retain) id<CategorySelectionDelegate> delegate;
@end