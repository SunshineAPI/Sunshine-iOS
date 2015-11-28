@protocol CategorySelectionDelegate <NSObject>
@required
-(void)didSelectCategory:(NSString*)categoryId withName:(NSString*)categoryName;
@end