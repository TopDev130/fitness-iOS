
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NODE_CATEGORY,
    NODE_EVENT,
    NODE_DETAIL,
    
} TREE_NODE_TYPE;

@interface RADataObject : NSObject

@property (strong, nonatomic) NSString          *name;
@property (strong, nonatomic) NSArray           *children;
@property (assign, nonatomic) TREE_NODE_TYPE    type;
@property (strong, nonatomic) Event             *event;
@property (assign, nonatomic) int               index;

- (id)initWithName:(NSString *)name children:(NSArray *)array;
- (id)initWithName:(NSString *)name children:(NSArray *)children type: (TREE_NODE_TYPE) type;
- (id)initWithEvent:(Event *)e children:(NSArray *)children type: (TREE_NODE_TYPE) type;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children type: (TREE_NODE_TYPE) type;

- (void)addChild:(id)child;
- (void)removeChild:(id)child;

@end