//
//  NewsViewController.h
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewModel.h"

@interface NewsViewController : UIViewController

@property (strong, nonatomic) NewsViewModel *newsViewModel;

@end
