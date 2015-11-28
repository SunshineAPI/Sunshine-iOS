@interface ForumsHelper : NSObject
+ (void)getCategories:(void (^)(NSArray *categories))categoriesSuccess;
@end