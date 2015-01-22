//
//  BaseEmojiBoard.m
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "BaseEmojiBoard.h"
@interface BaseEmojiBoard()<UIScrollViewDelegate>
{
    UIPageControl *facePageControl;
    UIScrollView *faceView;
    
    NSArray *faceKeysArr;
    NSDictionary *baseimgDic;
    
    NSRegularExpression *emojiRegular;
}
@end

@implementation BaseEmojiBoard

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightTextColor];
        
        faceKeysArr = [NSArray arrayWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"expression_custom"
                                                     ofType:@"plist"]];
        baseimgDic = [NSDictionary dictionaryWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"expressionImage_custom"
                                                                ofType:@"plist"]];
        NSInteger faceSumCount = [faceKeysArr count];
        
        //正则，匹配 [中文，字母]
        emojiRegular = [[NSRegularExpression alloc] initWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kFaceContainViewHeight)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake(((faceSumCount -1 )/ FACE_COUNT_PAGE + 1) * frame.size.width, kFaceContainViewHeight);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        [self addSubview:faceView];
        
        CGFloat itemHorizoneSpace = (frame.size.width - FACE_ICON_SIZE * FACE_COUNT_CLU ) / 8.0f;
        for (int i = 0; i < [faceKeysArr count]; i++) {
            
            ZLFaceButton *faceButton = [ZLFaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            NSInteger indexx = (i % FACE_COUNT_PAGE % FACE_COUNT_CLU)+1;
            CGFloat x = (i % FACE_COUNT_PAGE % FACE_COUNT_CLU) * FACE_ICON_SIZE + indexx*itemHorizoneSpace + i / FACE_COUNT_PAGE *  frame.size.width;
            CGFloat y = ((i % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
            faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
            
            [faceButton setImage:[UIImage imageNamed:[baseimgDic objectForKey:faceKeysArr[i]]]
                        forState:UIControlStateNormal];
            
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((frame.size.width-100)/2.0f, kFaceContainViewHeight, 100, 20)];
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        facePageControl.numberOfPages = (faceSumCount - 1) / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        facePageControl.pageIndicatorTintColor = [UIColor redColor];
        facePageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
        [self addSubview:facePageControl];
        
        //发送键
        UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
        [send setTitle:@"发送" forState:UIControlStateNormal];
        [send addTarget:self action:@selector(sendFace) forControlEvents:UIControlEventTouchUpInside];
        send.frame = CGRectMake(frame.size.width-90,kFaceContainViewHeight, 38, 28);
        [self addSubview:send];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(frame.size.width-50,kFaceContainViewHeight, 38, 28);
        [self addSubview:back];
    }
    
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [facePageControl setCurrentPage:faceView.contentOffset.x / 320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * 320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    
    NSInteger i = ((ZLFaceButton*)sender).buttonIndex;
    
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:faceKeysArr[i]];
        self.inputTextView.text = faceString;
        [self.delegate textViewDidChange:self.inputTextView];
    }
}
-(void)sendFace{
    [self.delegate sendFaceContent:self.inputTextView];
}
- (void)backFace{
    
    NSString *inputString;
    if ( self.inputTextView ) {
        inputString = self.inputTextView.text;
    }
    
    if (inputString.length) {
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if (stringLength>=3 && [inputString hasSuffix:@"]"]) {
            NSArray *emojis = nil;
            emojis = [emojiRegular matchesInString:inputString options:NSMatchingWithTransparentBounds range:NSMakeRange(0,stringLength)];
            NSTextCheckingResult *resultlast = [emojis lastObject];
            
            NSRange range = resultlast.range;
            NSString *emojiKey = [inputString substringWithRange:range];
            
            if([baseimgDic objectForKey:emojiKey]){
                string = [inputString substringWithRange:NSMakeRange(0, range.location)];
            }else{
                string = [inputString substringToIndex:stringLength - 1];
            }
        }else{
            string = [inputString substringToIndex:stringLength - 1];
        }
        
        if ( self.inputTextView ) {
            self.inputTextView.text = string;
            [self.delegate textViewDidChange:self.inputTextView];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
