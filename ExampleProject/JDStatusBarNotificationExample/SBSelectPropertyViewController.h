//
//  SBSelectPropertyViewController.h
//  JDStatusBarNotificationExample
//
//  Created by Markus Emrich on 09.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SBSelectPropertyResultBlock)(NSInteger selectedRow);

@interface SBSelectPropertyViewController : UITableViewController

@property (nonatomic, assign) NSInteger activeRow;

- (id)initWithData:(NSArray*)data
       resultBlock:(SBSelectPropertyResultBlock)resultBlock;

@end
