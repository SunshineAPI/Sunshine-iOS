#import "Post.h"

@implementation PostObject
@synthesize postId;
@synthesize text;
@synthesize author;

-(id)initJSON:(NSDictionary*)data{
  self = [super init];
  if (self){
    self.postId = [data objectForKey:@"id"];
    self.text = [data objectForKey:@"content"];
    self.author = [data objectForKey:@"author"];
  }
  return self;
}

@end