//
//  BaseEmojiBoard.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLFaceButton.h"

#define FACE_NAME_HEAD  @"/s"

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   5

#define FACE_COUNT_ROW  4
#define FACE_COUNT_CLU  7
#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )
#define FACE_ICON_SIZE  44

#define kFaceContainViewHeight 190

@protocol BaseEmojiBoardDelegate <NSObject>
@optional
- (void)textViewDidChange:(UITextView *)textView;
- (void)sendFaceContent:(UITextView *)textView;
@end

@interface BaseEmojiBoard : UIView
@property (nonatomic, assign) id<BaseEmojiBoardDelegate> delegate;
@property (nonatomic, strong) UITextView *inputTextView;
@end
