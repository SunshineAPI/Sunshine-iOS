#import "Topic.h"
@implementation TopicObject
@synthesize topicId;

-(id)initJSON:(NSDictionary*)data{
    self = [super init];
    if(self){
        //NSLog(@"initWithJSONData method called");
        self.topicId = [data objectForKey:@"title"];;
    }
    return self;
}
@end