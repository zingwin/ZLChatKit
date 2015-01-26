//
//  ViewController.m
//  ZLChatKit
//
//  Created by zingwin on 15/1/26.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()<ZLChatViewControllerDelegate>
@end

@implementation ViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

-(BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%3==0) {
        return YES;
    }
    return NO;
}
@end
