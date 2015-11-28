#import <Foundation/Foundation.h>

@interface TopicObject : NSObject
@property (nonatomic, retain) NSString *topicId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *author;
@property (nonatomic) NSInteger pageCount;

-(id)initJSON:(NSDictionary*)data;
@end