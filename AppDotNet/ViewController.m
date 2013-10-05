//
//  ViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/4/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
    
    
    
    return cell;
}

@end
