//
//  AppDelegate.m
//  LZUmengShare
//
//  Created by liuzhu on 15/12/7.
//  Copyright © 2015年 liuzhu. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //配置友盟五个常用平台的sso分享
    [self configUMengSSOShare];
    
    return YES;
}

/**
 *  配置友盟五个常用平台的sso分享
 */
- (void)configUMengSSOShare{
    
    //初始化appkey
    [UMSocialData setAppKey:@"55efd98de0f55aca82003bbe"];
    
    //打开友盟的日志
//    [UMSocialData openLog:YES];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx186ca1f9eb9b3301" appSecret:@"93a5f187b63b363dd473ee46acea24cb" url:@"http://www.umeng.com/social"];
    
    //注册qq的单点登录/分享
    [UMSocialQQHandler setQQWithAppId:@"1104829929" appKey:@"GkhDw9rE8Uh84XW8" url:@"http://www.umeng.com/social"];
    
    //微博,此处的 url 必须和注册的时候一样,否则会重定向失败.
    [UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2/default.html"];

    //让分享界面支持横屏竖屏
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
}

/**
 *  当从分享平台跳到当前程序时,会触发的代理方法
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return YES;
}

@end
