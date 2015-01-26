//
//  ZLRecordAnimationView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/21.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RecordStatus){
    RS_StartRecord = 0,
    RS_CancelRecord,
    RS_StopRecord,
};

@interface ZLRecordAnimationView : UIView
// 录音按钮按下
-(void)recordButtonTouchDown;
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside;
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside;
// 手指移动到录音按钮内部
-(void)recordButtonDragInside;
// 手指移动到录音按钮外部
-(void)recordButtonDragOutside;

@end
