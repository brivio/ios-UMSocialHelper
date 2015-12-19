#import <Foundation/Foundation.h>
#import <ios-UMSocialHelper/UMSocialControllerService.h>

@interface UMSocialHelperConfig : NSObject

@property(strong, nonatomic) NSString *um_app_key;
@property(strong, nonatomic) NSString *wb_app_key;
@property(strong, nonatomic) NSString *wx_app_key;
@property(strong, nonatomic) NSString *wx_app_secret;
@property(strong, nonatomic) NSString *qq_app_key;
@property(strong, nonatomic) NSString *qq_app_secret;

@end

@interface UMSocialHelper : NSObject <UMSocialUIDelegate>
typedef void(^UMSocialLoginCallback)(NSString *type, NSString *access_token, NSString *user_name, NSString *avatar);

@property(strong, nonatomic) NSString *TYPE_QQ;
@property(strong, nonatomic) NSString *TYPE_WEIBO;
@property(strong, nonatomic) NSString *TYPE_WEIXIN;

- (instancetype)initWithConfig:(UMSocialHelperConfig *)config;

- (void)doLogin:(UIViewController *)controller type:(NSString *)type callback:(UMSocialLoginCallback)callback;

- (void)doShare:(UIViewController *)controller title:(NSString *)title content:(NSString *)content url:(NSString *)url img:(NSString *)img;

- (BOOL)isInstalled:(NSString *)type;

//需要添加到 AppDelegate中的application:handleOpenURL:
+ (BOOL)handleOpenURL:(NSURL *)url;
@end