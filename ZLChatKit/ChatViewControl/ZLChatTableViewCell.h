//
//  ZLChatTableViewCell.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "ZLChatBaseBubbleView.h"
#import "ZLChatTextBubbleView.h"
#import "ZLChatAudioBubbleView.h"
#import "ZLChatImageBubbleView.h"
#import "ZLChatVideoBubbleView.h"
#import "ZLChatLocationBubbleView.h"

#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 5 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 8 // Cell之间间距
#define kTimestampHeight 20

#define NAME_LABEL_WIDTH 180 // nameLabel宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 0 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体

#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

//@protocol ZLChatTableViewCellDelegate <NSObject>
//-(BOOL)isShowTimestamp:(NSIndexPath*)indexPath;  //default : 显示时间戳
//@end

@interface ZLChatTableViewCell : UITableViewCell
//@property(nonatomic,assign) id<ZLChatTableViewCellDelegate> delegate;

@property (nonatomic, strong) MessageModel *messageModel;

@property(nonatomic,strong) UILabel *timestampLabel;
@property (nonatomic, strong) UIImageView *headImageView;       //头像
@property (nonatomic, strong) UILabel *nameLabel;               //姓名（暂时不支持显示）
@property (nonatomic, strong) ZLChatBaseBubbleView *bubbleView;   //内容区域

//sender
@property (nonatomic, strong) UIActivityIndicatorView *activtiy;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;
//- (void)setupSubviewsForMessageModel:(MessageModel *)model;
- (void)configureCellWithMessage:(MessageModel*)message displaysTimestamp:(BOOL)displayts;

+ (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model;
+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model;

@end
