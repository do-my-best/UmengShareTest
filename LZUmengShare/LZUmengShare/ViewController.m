//
//  ViewController.m
//  LZUmengShare
//
//  Created by liuzhu on 15/12/7.
//  Copyright © 2015年 liuzhu. All rights reserved.
//
#import "ViewController.h"
#import "UMSocial.h"



@interface ViewController ()<UMSocialUIDelegate>

/**
 *  将要跳转的分享的地址
 */
@property ( nonatomic, copy )NSString *destUrlString;

/**
 *  当前房间名的字符串
 */
@property ( nonatomic, copy )NSString *currentRoomStr;

/**
 *  当前房间地址的字符串
 */
@property ( nonatomic, copy )NSString *currentURLStr;

/**
 *  当前房间的截图内容
 */
@property ( nonatomic,  strong )UIImage *currentScreenShot;

@end

@implementation ViewController


/**
 *  用户点击分享按钮的时候会触发友盟分享的弹框
 *
 *  @param sender 分享按钮
 */
- (IBAction)shareWithUM:(id)sender {
    
    //打开分享窗口
    [self openSharePlatformListWithAppKey:@"55efd98de0f55aca82003bbe"
                              currentRoom:@"房间1"
                               currentURL:@"http://panda.tv"
                        currentScreenShot:[UIImage imageNamed:@"lushi"]];
    
}

#pragma mark - 以下方法可以不管,直接调用以上方法就可以实现分享功能.


/**
 *  打开不同平台列表的函数
 *
 *  要拼接的字符串默认是:我正在熊猫TV观看直播“直播的房间名”，+ 直播的url，欢迎大家来围观。
 *
 *  @param appkey      在友盟注册过的appkey
 *  @param currentRoom 当前的房间名称
 *  @param url         当前房间的 url 地址
 *  @param image       当前房间的截图
 */
- (void)openSharePlatformListWithAppKey:(NSString *)appkey
                            currentRoom:(NSString *)currentRoom
                             currentURL:(NSString *)url
                      currentScreenShot:(UIImage *)image{
    
    //初始化本地的 url 等字符串
    self.currentRoomStr = currentRoom;
    self.currentURLStr = url;
    self.currentScreenShot = image;
    
    //保存分享的内容
    NSString *shareText = [NSString stringWithFormat:@"我正在熊猫TV观看直播“%@”%@，欢迎大家来围观。",currentRoom,url];
    //打开友盟默认的分享列表界面
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:appkey
                                      shareText:shareText
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ]
                                       delegate:self];
}


#pragma mark - delegate method <UMSocialUIDelegate>
/**
 *  当用户选择某个分享平台时会触发此代理方法,可以在此方法中设置分享的内容.
 *
 *  @param platformName 用户选择的分享平台的名称
 *  @param socialData   用户传入的分享平台的数据
 */
- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
    //判断不同的平台
    if ([platformName isEqualToString:@"wxsession"]) {
        
        socialData.extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeApp;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.currentRoomStr;
        
    }else if([platformName isEqualToString:@"wxtimeline"]){
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.currentRoomStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.currentURLStr;
        
    }else if ([platformName isEqualToString:@"qzone"] ){
        
        [UMSocialData defaultData].extConfig.qzoneData.title = self.currentRoomStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = self.currentURLStr;
        
    } else if ([platformName isEqualToString:@"qq"]){
        
        [UMSocialData defaultData].extConfig.qqData.title = self.currentRoomStr;
        [UMSocialData defaultData].extConfig.qqData.url = self.currentURLStr;
        
    }else if ([platformName isEqualToString:@"sina"]){
        
    }
    
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    UIAlertView *alertView = nil;
    
    if(response.responseCode == 200){
    
         alertView = [[UIAlertView alloc]initWithTitle: nil
                                  message:@"分享成功"
                                 delegate:self
                        cancelButtonTitle:nil
                        otherButtonTitles:@"确定", nil];
        
    }else{
    
        alertView = [[UIAlertView alloc]initWithTitle: nil
                                              message:@"分享失败"
                                             delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"确定", nil];
    }
    
    [alertView show];

}


/**
 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
 
 */
- (BOOL)isDirectShareInIconActionSheet{
    
    return NO;
}




@end
