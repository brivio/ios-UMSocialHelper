#import "UMSocialHelper.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"
#import "UMSocialWechatHandler.h"
#import "TencentApiInterface.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialAccountManager.h"
#import "UMPlatform.h"
#import "UMShareVC.h"
#import "View+MASAdditions.h"
#import "Extend.h"
#import <pop/POP.h>

@implementation UMSocialHelperConfig
@end

@implementation UMSocialHelper {
    NSString *_url;
    UMSocialHelperConfig *_config;
    NSDictionary *_platformDict;
    UMShareVC *_shareVC;
    UIView *_shadowView;
}
- (instancetype)initWithConfig:(UMSocialHelperConfig *)config {
    _config = config;
    self = [super init];
    if (self) {
        _TYPE_QQ = @"qq";
        _TYPE_WEIBO = @"wb";
        _TYPE_WEIXIN = @"wx";

        [UMSocialData setAppKey:_config.um_app_key];
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
                    UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary] valueForKey:_type];

                    if (account) {
                        NSString *openid = account.openId;
                        if (type == _TYPE_WEIBO) {
                            openid = account.usid;
                        }
                        callback(type, openid, account.userName, account.iconURL);
                    } else {
                        NSLog(@"%s(%d)获取account失败！移动应用可能审核未通过", __FILE__, __LINE__);
                    }
                }
            });
}

- (void)doShare:(UIViewController *)controller title:(NSString *)title content:(NSString *)content url:(NSString *)url img:(NSString *)img {
    _url = url;
    [self setup];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = url;

    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;

    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@", content, url];

    CGFloat shareViewHeight = [UIScreen width] / 2;
    if (_shadowView == nil) {
        NSMutableArray *names = [NSMutableArray new];
        if ([self isInstalled:_TYPE_WEIXIN]) {
            [names addObjectsFromArray:@[
                    //微信
                    UMShareToWechatSession, UMShareToWechatTimeline, UMShareToWechatFavorite,
            ]];
        }
        if ([self isInstalled:_TYPE_QQ]) {
            [names addObjectsFromArray:@[
                    //QQ、QQ空间
                    UMShareToQzone, UMShareToQQ,
            ]];
        }
        [names addObjectsFromArray:@[
                //新浪微博
                UMShareToSina,
                //短信
                UMShareToSms,
                //邮件
                UMShareToEmail,
        ]];

        NSMutableArray *platforms = [NSMutableArray new];
        for (NSString *name in names) {
            UMPlatform *platform = [UMPlatform new];
            platform.name = name;
            NSArray *res = _platformDict[name];
            platform.title = res[0];
            platform.icon = res[1];
            [platforms addObject:platform];
        }

        _shadowView = [UIView new];
        [controller.view addSubview:_shadowView];
        [_shadowView click:self action:@selector(shadowViewClick)];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_shadowView.superview);
            make.center.equalTo(_shadowView.superview);
        }];

        _shareVC = [UMShareVC new];
        _shareVC.platformList = platforms;
        _shareVC.shareTitle = title;
        _shareVC.shareContent = content;
        _shareVC.shareImg = img;
        _shareVC.shareUrl = url;
        _shareVC.controller = controller;
        _shareVC.shareBGColor = _shareBGColor;
        _shareVC.shareHoverColor = _shareHoverColor;

        [controller.view addSubview:_shareVC.view];
        [_shareVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(shareViewHeight);
            make.bottom.equalTo(_shadowView.mas_bottom).offset(shareViewHeight);
            make.leading.and.trailing.equalTo(_shadowView);
        }];
    }
    _shadowView.hidden = NO;
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animation.fromValue = @([UIScreen height] + 200);
    animation.toValue = @([UIScreen height] - shareViewHeight / 2 + controller.view.bounds.origin.y);
    animation.duration = 0.2f;
    [_shareVC.view pop_addAnimation:animation forKey:@"show"];
}

- (void)shadowViewClick {
    _shadowView.hidden = YES;
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animation.toValue = @([UIScreen height] + 200);
    animation.duration = 0.2f;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
    }];
    [_shareVC.view pop_addAnimation:animation forKey:@"hide"];
}

- (void)setup {
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
    [UMSocialConfig setTheme:UMSocialThemeBlack];

    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:_config.wb_app_key RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //微信
    [UMSocialWechatHandler setWXAppId:_config.wx_app_key
                            appSecret:_config.wx_app_secret
                                  url:_url];
    //QQ、QQ空间
    [UMSocialQQHandler setQQWithAppId:_config.qq_app_key
                               appKey:_config.qq_app_secret
                                  url:_url];
    _platformDict = [NSDictionary new];
    _platformDict = @{
            UMShareToWechatSession : @[@"微信好友", @"UMS_wechat_session_icon"],
            UMShareToWechatTimeline : @[@"微信朋友圈", @"UMS_wechat_timeline_icon"],
            UMShareToWechatFavorite : @[@"微信收藏", @"UMS_wechat_favorite_icon"],
            UMShareToQzone : @[@"QQ空间", @"UMS_qzone_icon"],
            UMShareToQQ : @[@"QQ", @"UMS_qq_icon"],
            UMShareToSms : @[@"短信", @"UMS_sms_icon"],
            UMShareToEmail : @[@"邮件", @"UMS_email_icon"],
            UMShareToSina : @[@"新浪微博", @"UMS_sina_icon"],
    };

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