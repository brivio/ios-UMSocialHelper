#import "UMShareCell.h"
#import "UMPlatform.h"
#import "UIView+Extend.h"
#import "UMSocialSnsPlatformManager.h"

@implementation UMShareCell

- (void)awakeFromNib {

}

- (void)bind {
    _iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/%@.png", _data.icon]];
    _titleLabel.text = _data.title;
    [self click:self action:@selector(viewClick)];
}

- (void)viewClick {
    if ([_data.name isEqualToString:UMShareToSina]) {
        [[UMSocialControllerService defaultControllerService]
                setShareText:_shareContent
                  shareImage:_shareImageRes
            socialUIDelegate:nil];

        [UMSocialSnsPlatformManager getSocialPlatformWithName:_data.name].snsClickHandler(
                _controller,
                [UMSocialControllerService defaultControllerService],
                YES);
    } else {
        [[UMSocialDataService defaultDataService]
                postSNSWithTypes:@[_data.name]
                         content:_shareContent
                           image:_shareImageRes
                        location:nil
                     urlResource:nil
             presentedController:_controller
                      completion:^(UMSocialResponseEntity *response) {
                          if (response.responseCode == UMSResponseCodeSuccess) {
                          }
                      }];
    }
}
@end
