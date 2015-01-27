//
//  commonDefs.h
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#ifndef ZLChatKit_commonDefs_h
#define ZLChatKit_commonDefs_h

/*!
 @enum
 @brief 聊天类型
 @constant MessageBodyType_Text 文本类型
 @constant MessageBodyType_Image 图片类型
 @constant MessageBodyType_Video 视频类型
 @constant MessageBodyType_Location 位置类型
 @constant MessageBodyType_Voice 语音类型
 @constant MessageBodyType_File 文件类型
 @constant MessageBodyType_Command 命令类型
 */
typedef NS_ENUM(NSInteger, MessageBodyType) {
    MessageBodyType_Text = 1,
    MessageBodyType_Image,
    MessageBodyType_Video,
    MessageBodyType_Location,
    MessageBodyType_Voice,
    MessageBodyType_File,
    MessageBodyType_Command
};
/*!
 @enum
 @brief 聊天消息发送状态
 @constant MessageDeliveryState_Pending 待发送
 @constant MessageDeliveryState_Delivering 正在发送
 @constant MessageDeliveryState_Delivered 已发送, 成功
 @constant MessageDeliveryState_Failure 已发送, 失败
 */
typedef NS_ENUM(NSInteger, MessageDeliveryState){
    MessageDeliveryState_Pending = 0,
    MessageDeliveryState_Delivering,
    MessageDeliveryState_Delivered,
    MessageDeliveryState_Failure
};


/**
 *  发送音频的时候各个状态
 */
typedef NS_ENUM(NSInteger, SendVoiceStatus) {
    VS_didStartRecordingVoice,
    VS_didCancelRecordingVoice,
    VS_didFinishRecoingVoice,
    VS_didDragOutside,  //当手指离开按钮的范围内时，主要为了通知外部的HUD
    VS_didDragInside,
    VS_resumeRecordVoice, //恢复录音
    VS_pauseRecordVoice,  //暂停
};
//#define kPushNotificationMaskDisplayStyle      0x01
//#define kPushNotificationMaskNickname          0x01<<1
//#define kPushNotificationMaskNoDisturbing      0x01<<2
//#define kPushNotificationMaskNoDisturbingStart 0x01<<3
//#define kPushNotificationMaskNoDisturbingEnd   0x01<<4
//#define kPushNotificationMaskAll               0x01<<7

#endif
