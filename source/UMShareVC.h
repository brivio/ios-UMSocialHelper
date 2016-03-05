#import <Foundation/Foundation.h>

@class UMSocialUrlResource;

@interface UMShareVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) NSArray *platformList;
@property(strong, nonatomic) NSString *shareTitle;
@property(strong, nonatomic) NSString *shareContent;
@property(strong, nonatomic) NSString *shareUrl;
@property(strong, nonatomic) NSString *shareImg;
@property(strong, nonatomic) UIViewController *controller;
@property(strong, nonatomic) UIColor *shareBGColor;
@property(strong, nonatomic) UIColor *shareHoverColor;
@end