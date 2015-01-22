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
}
@property(nonatomic,strong) UITableView *chatTableView;
@property(nonatomic,strong) ZLInputToolView *chatToolBar;
@property(nonatomic,strong) NSMutableArray *messagesArr;
@end

@implementation ZLChatViewController
@synthesize chatTableView,chatToolBar,messagesArr;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    messagesArr = [[NSMutableArray alloc]  init];
    _messageQueue = dispatch_queue_create("com.weibo.zwin", NULL);
    
    chatToolBar = [[ZLInputToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [ZLInputToolView defaultHeight], self.view.frame.size.width, [ZLInputToolView defaultHeight])];
    chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    chatToolBar.delegate = self;
    [self.view addSubview:self.chatToolBar];
    
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
    chatTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor clearColor];
    chatTableView.tableFooterView = [[UIView alloc] init];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5;
    [chatTableView addGestureRecognizer:lpgr];
    [self.view addSubview:self.chatTableView];
    
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
    model.type = eMessageBodyType_Text;
    model.content = @"哈哈哈哈哈微笑[微笑][白眼][白眼][白眼][白眼]微笑[愉快][冷汗][投降]哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    model.isSender = rand()%2;
    [self.messagesArr addObject:model];
    
    model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Image;
    model.size = CGSizeMake(200, 200);
    model.image = [UIImage imageNamed:@"p3.jpg"];
    model.isSender = rand()%2;
        [self.messagesArr addObject:model];

    model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Voice;
    model.time = 4;
    model.isPlaying = NO;
    model.localPath = @"";
    model.isSender = rand()%2;
        [self.messagesArr addObject:model];
    
    [self.chatTableView reloadData];
    
}
#pragma mark - ZLInputToolViewDelegate
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    ZLRecordAnimationView *tmpView = (ZLRecordAnimationView *)recordView;
    tmpView.center = self.view.center;
    [self.view addSubview:tmpView];
    [self.view bringSubviewToFront:recordView];
    
    NSLog(@"开始录音");
}
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
    model.type = eMessageBodyType_Text;
    model.content = text;
    model.isSender = rand()%2;
    [self addChatDataToMessage:model];
}

-(void)addChatDataToMessage:(MessageModel *)message
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

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        //[self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        //[self chatAudioCellBubblePressed:model];
        model.isPlaying = YES;
        [self.chatTableView reloadData];
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
    cell.messageModel = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.messagesArr objectAtIndex:indexPath.row];
    return [ZLChatTableViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
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
//        CGPoint location = [recognizer locationInView:self.chatTableView];
//        NSIndexPath * indexPath = [self.chatTableView indexPathForRowAtPoint:location];
//        id object = [self.messagesArr objectAtIndex:indexPath.row];
//        if ([object isKindOfClass:[MessageModel class]]) {
//            ZLChatTableViewCell *cell = (ZLChatTableViewCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
//            [cell becomeFirstResponder];
//            _longPressIndexPath = indexPath;
//            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
//        }
    }

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
