//
//  ChatViewController.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commonDefs.h"
#import "MessageModel.h"

@protocol ZLChatViewControllerDelegate<NSObject>
//是否显示时间戳
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)didComingRecordingVoiceStatus:(SendVoiceStatus)status;
@end

@interface ZLChatViewController : UIViewController
@property(nonatomic,assign) id<ZLChatViewControllerDelegate> delegate;


-(void)addMessage:(MessageModel *)message;
-(void)addMessages:(NSArray*)msges;
@end
