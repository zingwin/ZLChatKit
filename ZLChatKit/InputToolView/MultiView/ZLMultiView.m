//
//  ZLMultiView.m
//  ZLChatKit
//
//  Created by zingwin on 15/1/21.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ZLMultiView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8
#define kmutilButtonWidth 80

@implementation ZLMultiView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *ms = @[@"拍照",@"相册",@"位置",@"抖屏",@"微博"];
        CGFloat space = (frame.size.width - (kmutilButtonWidth*3)) / 4.0f;
        CGFloat offx = space;
        CGFloat offy = 10;
        
        for(int i = 0 ;i<[ms count];i++){
            offy = i / 3 * kmutilButtonWidth + 10*(i/3+1);
            offx = i % 3 * kmutilButtonWidth + space*(i%3+1) ;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offx,offy, kmutilButtonWidth, kmutilButtonWidth)];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 5.0f;
            [btn setTitle:ms[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.tag = 9090+i;
            [btn addTarget:self action:@selector(mutilButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)mutilButtonPressed:(UIButton*)sender
{
    switch (sender.tag) {
        case 9090+0:
        {
            NSLog(@"拍照被点击了");
        }
            break;
        case 9090+1:
        {
        }
            break;
        default:
            break;
    }
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

@end
