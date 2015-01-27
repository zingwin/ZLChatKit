//
//  InputToolView.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/21.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLFaceView.h"
#import "ZLMultiView.h"
#import "ZLInputMessageTextView.h"
#import "ZLRecordAnimationView.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 8
#define kVerticalPadding 5
#define kBottomContainViewHeight  216

#define kTouchToRecord @"按住说话"
#define kTouchToFinish @"松开发送"

@protocol ZLInputToolViewDelegate;
@interface ZLInputToolView : UIView
/**
 *  类说明：
 *  1、推荐使用[initWithFrame:...]方法进行初始化
 *  2、提供默认的录音，表情，更多按钮的附加页面
 *  3、可自定义以上的附加页面
 */

@property (nonatomic, weak) id <ZLInputToolViewDelegate> delegate;

/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 *  更多的附加页面
 */
@property (strong, nonatomic) UIView *moreView;

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;

/**
 *  录音的附加页面
 */
@property (strong, nonatomic) UIView *recordView;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) ZLInputMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return DXMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

/**
 *  取消触摸录音键
 */
- (void)cancelTouchRecord;

@end

@protocol ZLInputToolViewDelegate <NSObject>
@optional
/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(ZLInputMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(ZLInputMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

//***************语音相关事件*****************//
//按下录音按钮开始录音
- (void)didStartRecordingVoiceAction:(UIView *)recordView;
//手指向上滑动取消录音
- (void)didCancelRecordingVoiceAction:(UIView *)recordView;
//松开手指完成录音
- (void)didFinishRecoingVoiceAction:(UIView *)recordView;
//当手指离开按钮的范围内时，主要为了通知外部的HUD
- (void)didDragOutsideAction:(UIView *)recordView;
//当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
- (void)didDragInsideAction:(UIView *)recordView;
//在普通状态和语音状态之间进行切换时，会触发这个回调函数  changedToRecord 是否改为发送语音状态
- (void)didStyleChangeToRecord:(BOOL)changedToRecord;

//***************更多操作相关*****************//
- (void)didPressedTakePictureAction;
- (void)didPressedSelectAlbumAction;


@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

@end
