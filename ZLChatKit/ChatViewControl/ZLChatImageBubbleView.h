//
//  ZLChatImageBubbleView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ZLChatBaseBubbleView.h"

#define MAX_SIZE 120 //　图片最大显示大小

extern NSString *const kRouterEventImageBubbleTapEventName;

@interface ZLChatImageBubbleView : ZLChatBaseBubbleView

@property (nonatomic, strong) UIImageView *imageView;

@end
