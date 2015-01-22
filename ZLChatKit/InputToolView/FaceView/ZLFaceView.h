//
//  ZLFaceView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/21.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEmojiBoard.h"

@protocol ZLFaceViewDelegate <BaseEmojiBoardDelegate>
@end

@interface ZLFaceView : UIView
@property (nonatomic, assign) id<ZLFaceViewDelegate> delegate;
@property (nonatomic,strong) UITextView *inputTextView;
@end
