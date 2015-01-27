//
//  ChatViewController.m
//  ZLChatKit
//
//  Created by zingwin on 15/1/22.
//  Copyright (c) 2015年 zingwin. All rights reserved.
//

#import "ZLChatViewController.h"
#import "ZLInputToolView.h"
#import "ZLChatTableViewCell.h"

@interface ZLChatViewController ()<UITableViewDataSource, UITableViewDelegate,ZLInputToolViewDelegate>
{
     dispatch_queue_t _messageQueue;
    
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
}
@property(nonatomic,strong) UITableView *chatTableView;
@property(nonatomic,strong) ZLInputToolView *chatToolBar;
@property(nonatomic,strong) NSMutableArray *messagesArr;
@end

@implementation ZLChatViewController
@synthesize chatTableView,chatToolBar,messagesArr;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    messagesArr = [[NSMutableArray alloc]  init];
    _messageQueue = dispatch_queue_create("com.weibo.zwin", NULL);

    chatToolBar = [[ZLInputToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [ZLInputToolView defaultHeight], self.view.frame.size.width, [ZLInputToolView defaultHeight])];
    chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    chatToolBar.delegate = self;
    [self.view addSubview:self.chatToolBar];
    
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height-64) style:UITableViewStylePlain];
    chatTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor clearColor];
    chatTableView.tableFooterView = [[UIView alloc] init];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5;
    [chatTableView addGestureRecognizer:lpgr];
    [self.view addSubview:self.chatTableView];
    [self.view bringSubviewToFront:chatToolBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MessageModel *model = nil;
    model = [[MessageModel alloc] init];
    model.type = MessageBodyType_Text;
    model.content = @"哈哈哈哈哈微笑[微笑][白眼][白眼][白眼][白眼]微笑[愉快][冷汗][投降]哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    model.isSender = rand()%2;
    [self.messagesArr addObject:model];
    
    model = [[MessageModel alloc] init];
    model.type = MessageBodyType_Image;
    model.size = CGSizeMake(200, 200);
    model.image = [UIImage imageNamed:@"p3.jpg"];
    model.isSender = rand()%2;
        [self.messagesArr addObject:model];

    model = [[MessageModel alloc] init];
    model.type = MessageBodyType_Voice;
    model.time = 4;
    model.isPlaying = NO;
    model.localPath = @"";
    model.isSender = rand()%2;
        [self.messagesArr addObject:model];
    
    [self.chatTableView reloadData];
    
}

#pragma mark - VoiceAction Delegate
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    ZLRecordAnimationView *tmpView = (ZLRecordAnimationView *)recordView;
    tmpView.center = self.view.center;
    [self.view addSubview:tmpView];
    [self.view bringSubviewToFront:recordView];
    
    NSLog(@"开始录音");
    if ([self.delegate respondsToSelector:@selector(didComingRecordingVoiceStatus:)]) {
        [self.delegate didComingRecordingVoiceStatus:VS_didStartRecordingVoice];
    }
}
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    NSLog(@"完成录音");
    if ([self.delegate respondsToSelector:@selector(didComingRecordingVoiceStatus:)]) {
        [self.delegate didComingRecordingVoiceStatus:VS_didFinishRecoingVoice];
    }
    
}
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(didComingRecordingVoiceStatus:)]) {
        [self.delegate didComingRecordingVoiceStatus:VS_didCancelRecordingVoice];
    }
}
- (void)didDragOutsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(didComingRecordingVoiceStatus:)]) {
        [self.delegate didComingRecordingVoiceStatus:VS_pauseRecordVoice];
    }
}
- (void)didDragInsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(didComingRecordingVoiceStatus:)]) {
        [self.delegate didComingRecordingVoiceStatus:VS_resumeRecordVoice];
    }
}
#pragma mark - ZLInputToolViewDelegate
- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.chatTableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.chatTableView.frame = rect;
    }];
    [self scrollViewToBottom:YES];
}
- (void)didSendText:(NSString *)text
{
    if (text && text.length <= 0) return;
    
    MessageModel *model = [[MessageModel alloc] init];
    model.type = MessageBodyType_Text;
    model.content = text;
    model.isSender = rand()%2;
    [self addMessage:model];
}

-(void)addMessage:(MessageModel *)message
{
    __weak ZLChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (int i = 0; i < 1; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.messagesArr.count+i inSection:0];
            [indexPaths addObject:indexPath];
        }
        [weakSelf.messagesArr addObject:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.chatTableView beginUpdates];
            [weakSelf.chatTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.chatTableView endUpdates];
            [weakSelf.chatTableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}
static CGPoint  delayOffset = {0.0};
// http://stackoverflow.com/a/11602040 Keep UITableView static when inserting rows at the top
-(void)addMessages:(NSArray *)msges
{
     __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *msgestt = [NSMutableArray arrayWithArray:msges];
        [msgestt addObjectsFromArray:weakSelf.messagesArr];
        
        delayOffset = weakSelf.chatTableView.contentOffset;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:msges.count];
        [msges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
            
            delayOffset.y += [weakSelf calculateCellHeightWithMessage:[msgestt objectAtIndex:idx] atIndexPath:indexPath];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:NO];
            [weakSelf.chatTableView beginUpdates];
            weakSelf.messagesArr = msgestt;
            [weakSelf.chatTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            
            [weakSelf.chatTableView setContentOffset:delayOffset animated:NO];
            [weakSelf.chatTableView endUpdates];
            [UIView setAnimationsEnabled:YES];
        });
    });
}
#pragma mark - ZLMultiView delegate
-(void)didPressedSelectAlbumAction
{
    NSLog(@"选择相册");
}
-(void)didPressedTakePictureAction
{
    NSLog(@"拍照点击");
}

#pragma mark - UIResponder actions
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        //[self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        //[self chatAudioCellBubblePressed:model];
        ZLChatAudioBubbleView *v = [userInfo objectForKey:@"view"];
        [v startAudioAnimation];
        [v stopAudioAnimation];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        //[self chatImageCellBubblePressed:model];
        NSLog(@"点击了图片");
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        //[self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        //[self chatVideoCellPressed:model];
    }
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messagesArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = [self.messagesArr objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [ZLChatTableViewCell cellIdentifierForMessageModel:model];
    ZLChatTableViewCell *cell = (ZLChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZLChatTableViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    [cell configureCellWithMessage:model displaysTimestamp:displayTimestamp];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *message = [self.messagesArr objectAtIndex:indexPath.row];
//    CGFloat cellHeight = 0;
//    BOOL displayTimestamp = YES;
//    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
//        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
//    }
//    cellHeight = [ZLChatTableViewCell cellHeightForRowAtIndexPath:indexPath withObject:message];
//    return cellHeight + (displayTimestamp?kTimestampHeight:0);
    return [self calculateCellHeightWithMessage:message atIndexPath:indexPath];
}
- (CGFloat)calculateCellHeightWithMessage:(MessageModel*)message atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    cellHeight = [ZLChatTableViewCell cellHeightForRowAtIndexPath:indexPath withObject:message];
    return cellHeight + (displayTimestamp?kTimestampHeight:0);
}

#pragma mark - private
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.chatTableView.contentSize.height > self.chatTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height);
        [self.chatTableView setContentOffset:offset animated:YES];
    }
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.messagesArr count] > 0) {
        CGPoint location = [recognizer locationInView:self.chatTableView];
        NSIndexPath * indexPath = [self.chatTableView indexPathForRowAtPoint:location];
        id object = [self.messagesArr objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            ZLChatTableViewCell *cell = (ZLChatTableViewCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }

    if (messageType == MessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem]];
        [_menuController setTargetRect:showInView.frame inView:showInView.superview];
        [_menuController setMenuVisible:YES animated:YES];
    }
}
//如果需要显示菜单，必须实现以下2个方法
-(BOOL) canBecomeFirstResponder{
    return YES;
}
-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyMenuAction:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}
- (void)copyMenuAction:(id)sender
{
    // todo by du. 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.messagesArr objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    _longPressIndexPath = nil;
}

-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
