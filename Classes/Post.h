#import <Foundation/Foundation.h>

@interface PostObject : NSObject
@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *text;

-(id)initJSON:(NSDictionary*)data;
@end