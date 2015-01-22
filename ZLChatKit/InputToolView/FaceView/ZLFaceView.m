//
//  ZLFaceView.m
//  ZLChatKit
//
//  Created by zingwin on 15/1/21.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ZLFaceView.h"
#import "BaseEmojiBoard.h"

@interface ZLFaceView ()<BaseEmojiBoardDelegate>
{
    BaseEmojiBoard *baseEmojiView;
}
@end

@implementation ZLFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        baseEmojiView = [[BaseEmojiBoard alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        baseEmojiView.delegate = self;
        [self addSubview:baseEmojiView];
    }
    return self;
}

-(void)setInputTextView:(UITextView *)inputTextView
{
    _inputTextView = inputTextView;
    baseEmojiView.inputTextView = inputTextView;
}

#pragma mark - public

#pragma mark - BaseEmojiBoardDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate textViewDidChange:textView];
}
- (void)sendFaceContent:(UITextView *)textView
{
    [self.delegate sendFaceContent:textView];
}
@end
