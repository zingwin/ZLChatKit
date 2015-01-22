//
//  ZLChatTextBubbleView.m
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ZLChatTextBubbleView.h"
NSString *const kRouterEventTextURLTapEventName = @"kRouterEventTextURLTapEventName";

@interface ZLChatTextBubbleView ()<MLEmojiLabelDelegate>
{
}

@end

@implementation ZLChatTextBubbleView
@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        textLabel = [[MLEmojiLabel alloc]init];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        textLabel.delegate = self;
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.isNeedAtAndPoundSign = YES;
        textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        textLabel.customEmojiPlistName = @"expressionImage_custom";
        [self addSubview:textLabel];
    }
    
    return self;
}
- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    if (model.isSender) {
        textLabel.textColor = [UIColor blackColor];
    }else{
        textLabel.textColor = [UIColor whiteColor];
    }
    textLabel.text = self.model.content;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize retSize = [textLabel preferredSizeWithMaxWidth:TEXTLABEL_MAX_WIDTH];
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.textLabel setFrame:frame];
}

- (CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return [textLabel preferredSizeWithMaxWidth:TEXTLABEL_MAX_WIDTH].height;
}

+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    CGSize size;
    static MLEmojiLabel *textLabel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textLabel = [[MLEmojiLabel alloc]init];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:15.0f];
    });
    textLabel.text = object.content;
    size = [textLabel preferredSizeWithMaxWidth:TEXTLABEL_MAX_WIDTH];
    return 2 * BUBBLE_VIEW_PADDING + size.height;
}
+ (UIFont *)textLabelFont
{
    return [UIFont systemFontOfSize:15];
}
+ (NSLineBreakMode)textLabelLineBreakModel
{
    return NSLineBreakByWordWrapping;
}
@end
