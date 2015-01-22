//
//  ZLMultiView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/21.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol ZLMultiViewDelegate;
@interface ZLMultiView : UIView
@property (nonatomic,assign) id<ZLMultiViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;

- (instancetype)initWithFrame:(CGRect)frame;// typw:(ChatMoreType)type;

//- (void)setupSubviewsForType:(ChatMoreType)type;
@end

@protocol ZLMultiViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(ZLMultiView *)moreView;
- (void)moreViewPhotoAction:(ZLMultiView *)moreView;
- (void)moreViewLocationAction:(ZLMultiView *)moreView;
- (void)moreViewVideoAction:(ZLMultiView *)moreView;
- (void)moreViewAudioCallAction:(ZLMultiView *)moreView;

@end
