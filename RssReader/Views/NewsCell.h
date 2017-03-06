//
//  NewsCell.h
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
