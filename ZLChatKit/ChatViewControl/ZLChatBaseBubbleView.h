//
//  ZLChatBaseBubbleView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "UIResponder+Router.h"

#define BUBBLE_LEFT_IMAGE_NAME @"ReceiverAppNode" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"SenderTextNode"
#define BUBBLE_ARROW_WIDTH 5 // bubbleView中，箭头的宽度
#define BUBBLE_VIEW_PADDING 8 // bubbleView 与 在其中的控件内边距

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 5 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 35 // 文字在右侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 35 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 35 // 文字在左侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_PROGRESSVIEW_HEIGHT 10 // progressView 高度

#define KMESSAGEKEY @"message"

extern NSString *const kRouterEventChatCellBubbleTapEventName;

@interface ZLChatBaseBubbleView : UIView
@property (nonatomic, strong) MessageModel *model;


@property (nonatomic, strong) UIImageView *backImageView;

- (void)bubbleViewPressed:(id)sender;


+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object;
@end
