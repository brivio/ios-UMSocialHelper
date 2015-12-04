#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"


@interface UMSocialHelper : NSObject <UMSocialUIDelegate>
typedef void(^UMSocialLoginCallback)(NSString *type, NSString *access_token, NSString *user_name, NSString *avatar);

@property(strong, nonatomic) NSString *TYPE_QQ;
@property(strong, nonatomic) NSString *TYPE_WEIBO;
@property(strong, nonatomic) NSString *TYPE_WEIXIN;

- (void)doLogin:(UIViewController *)controller type:(NSString *)type callback:(UMSocialLoginCallback)callback;

- (void)doShare:(UIViewController *)controller title:(NSString *)title content:(NSString *)content url:(NSString *)url img:(NSString *)img;

-(BOOL)isInstalled:(NSString *)type;

//需要添加到 AppDelegate中的application:handleOpenURL:
+ (BOOL)handleOpenURL:(NSURL *)url;
@end