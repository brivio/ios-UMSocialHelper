#import "UMSocialHelper.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialAccountManager.h"
#import "WXApi.h"

@implementation UMSocialHelper {
    NSString *_url;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _TYPE_QQ = @"qq";
        _TYPE_WEIBO = @"wb";
        _TYPE_WEIXIN = @"wx";

//        [UMSocialData setAppKey:UM_APP_KEY];
        //打开调试log的开关
        [UMSocialData openLog:NO];
    }

    return self;
}

- (void)doLogin:(UIViewController *)controller type:(NSString *)type callback:(UMSocialLoginCallback)callback {
    [self setup];
    NSString *_type;
    if (type == _TYPE_QQ) {
        _type = UMShareToQQ;
    }
    if (type == _TYPE_WEIBO) {
        _type = UMShareToSina;
    }
    if (type == _TYPE_WEIXIN) {
        _type = UMShareToWechatSession;
    }
    if (_type == nil)return;
    [UMSocialSnsPlatformManager getSocialPlatformWithName:_type].loginClickHandler(controller,
            [UMSocialControllerService defaultControllerService], YES,
            ^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary]
                            valueForKey:_type];
                    if (account) {
                        callback(type, account.openId, account.userName, account.iconURL);
                    } else {
                        NSLog(@"%s(%d)获取account失败！移动应用可能审核未通过", __FILE__, __LINE__);
                    }
                }
            });
}

- (void)doShare:(UIViewController *)controller title:(NSString *)title content:(NSString *)content url:(NSString *)url img:(NSString *)img {
    _url = url;
    [self setup];
    NSArray *names = @[
            //微信
            UMShareToWechatSession, UMShareToWechatTimeline, UMShareToWechatFavorite,
            //QQ、QQ空间
            UMShareToQzone, UMShareToQQ,
            //短信
            UMShareToSms,
            //邮件
            UMShareToEmail,
            //新浪微博
            UMShareToSina,
    ];

    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = url;

    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;

    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@", content, url];
    NSURL *imgUrl = [NSURL URLWithString:img];

//    [UMSocialSnsService presentSnsIconSheetView:controller
//                                         appKey:UM_APP_KEY
//                                      shareText:content
//                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]]
//                                shareToSnsNames:names
//                                       delegate:self];
}

- (void)setup {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatTimeline]];

//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WB_APP_KEY RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//
//    //微信
//    [UMSocialWechatHandler setWXAppId:WX_APP_KEY
//                            appSecret:WX_APP_SECRET
//                                  url:_url];
//    //QQ、QQ空间
//    [UMSocialQQHandler setQQWithAppId:QQ_APP_KEY
//                               appKey:QQ_APP_SECRET
//                                  url:_url];
}

- (BOOL)isInstalled:(NSString *)type {
    if ([type isEqualToString:_TYPE_WEIXIN]) {
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    }
    if ([type isEqualToString:_TYPE_QQ]) {
        return [QQApiInterface isQQInstalled];
    }
    return YES;
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

@end