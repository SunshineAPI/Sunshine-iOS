#import "Topic.h"
@implementation TopicObject
@synthesize topicId;
@synthesize title;

-(id)initJSON:(NSDictionary*)data{
    self = [super init];
    if(self){
        //NSLog(@"initWithJSONData method called");
        self.topicId = [data objectForKey:@"id"];
        self.title = [data objectForKey:@"title"];
    }
    return self;
}

@end