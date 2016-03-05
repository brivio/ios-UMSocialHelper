#import <UIKit/UIKit.h>

@class UMPlatform;

@interface UMShareCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UIImageView *iconImage;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)bind;

@property(strong, nonatomic) UMPlatform *data;
@property(strong, nonatomic) NSString *shareContent;
@property(strong, nonatomic) UIImage *shareImageRes;
@property(strong, nonatomic) UIViewController *controller;

@end
