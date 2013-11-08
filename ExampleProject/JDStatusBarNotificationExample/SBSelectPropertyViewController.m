//
//  SBSelectPropertyViewController.m
//  JDStatusBarNotificationExample
//
//  Created by Markus Emrich on 09.11.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBSelectPropertyViewController.h"

@interface SBSelectPropertyViewController ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) SBSelectPropertyResultBlock resultBlock;
@end

@implementation SBSelectPropertyViewController

- (id)initWithData:(NSArray*)data
       resultBlock:(SBSelectPropertyResultBlock)resultBlock;
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.data = data;
        self.resultBlock = resultBlock;
        self.activeRow = -1;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create / dequeue cell
    static NSString* identifier = @"identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    
    if (indexPath.row == self.activeRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (self.resultBlock) {
        self.resultBlock(indexPath.row);
    }
}

@end
