#import <Foundation/Foundation.h>
@interface TopicObject : NSObject

-(id)initJSON:(NSDictionary*)data;

@property (assign) NSString *topicId;

@end