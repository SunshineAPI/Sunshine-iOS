#import <Foundation/Foundation.h>
@interface TopicObject : NSObject

-(id)initJSON:(NSDictionary*)data;

@property (nonatomic, retain) NSString *topicId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *author;


@end