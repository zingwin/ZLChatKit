//
//  ChatViewController.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZLChatViewControllerDelegate<NSObject>
//是否显示时间戳
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZLChatViewController : UIViewController
@property(nonatomic,assign) id<ZLChatViewControllerDelegate> delegate;
@end
