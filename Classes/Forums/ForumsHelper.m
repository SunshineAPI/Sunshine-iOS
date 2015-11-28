#import "ForumsHelper.h"
#import "../AFNetworking/AFNetworking.h"

@implementation ForumsHelper
+ (void)getCategories:(void (^)(NSArray *categories))categoriesSuccess {
  NSString *apiCall = @"https://sunshine-api.com/forums/categories";

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager GET:apiCall
    parameters:nil
    success:^(NSURLSessionDataTask *task, id results) {
      NSMutableArray *categories  = [results objectForKey:@"data"];
      
      categoriesSuccess([categories copy]);
    }
    failure:nil];
}
@end