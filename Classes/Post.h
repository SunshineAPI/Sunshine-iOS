#import <Foundation/Foundation.h>

@interface PostObject : NSObject

-(id)initJSON:(NSDictionary*)data;

@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *text;

@end