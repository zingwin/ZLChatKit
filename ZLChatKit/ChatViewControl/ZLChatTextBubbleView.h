//
//  ZLChatTextBubbleView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ZLChatBaseBubbleView.h"
#import <CoreText/CoreText.h>
#import "MLEmojiLabel.h"    

#define TEXTLABEL_MAX_WIDTH 200 //　textLaebl 最大宽度
#define LABEL_FONT_SIZE 14

extern NSString *const kRouterEventTextURLTapEventName;

@interface ZLChatTextBubbleView : ZLChatBaseBubbleView
@property (nonatomic, strong) MLEmojiLabel *textLabel;

+ (UIFont *)textLabelFont;
+ (NSLineBreakMode)textLabelLineBreakModel;

@end
