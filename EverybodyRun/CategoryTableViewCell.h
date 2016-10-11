//
//  CategoryTableViewCell.h
//  EverybodyRun
//
//  Created by star on 2/27/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
{
    IBOutlet UILabel            *lbTitle;
    IBOutlet UILabel            *lbDescription;
}

- (void) setName: (NSString*) name count: (int) count level:(NSInteger)level;
@end
