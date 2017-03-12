//
//  Blog.m
//  EverybodyRun
//
//  Created by star on 4/17/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "Blog.h"

@implementation Blog

- (id) initWithDictionary: (NSDictionary*) dicBlog
{
    if(self = [super init])
    {
        self.blogId = [dicBlog[@"id"] intValue];
        self.title = dicBlog[@"title"][@"rendered"];
        self.content = dicBlog[@"content"][@"rendered"];
        self.link = dicBlog[@"link"];
        self.isRead = false;
        NSDictionary* links = dicBlog[@"_links"];
        NSArray* arrFeaturdMedia = links[@"https://api.w.org/featuredmedia"];
        if(arrFeaturdMedia != nil && [arrFeaturdMedia count] > 0)
        {
            NSDictionary* dicMedia = [arrFeaturdMedia firstObject];
            NSString* href = dicMedia[@"href"];
            
            self.mediaURL = href;
        }
    }
    
    return self;
}

@end
