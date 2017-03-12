//
//  Blog.h
//  EverybodyRun
//
//  Created by star on 4/17/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Blog : NSObject
{
    
}

@property (nonatomic)         int               blogId;
@property (nonatomic)         BOOL              isRead;
@property (nonatomic, retain) NSString          *title;
@property (nonatomic, retain) NSString          *content;
@property (nonatomic, retain) NSString          *mediaURL;
@property (nonatomic, retain) NSString          *link;
@property (nonatomic, retain) NSString          *imageURL;

- (id) initWithDictionary: (NSDictionary*) dicBlog;
@end
