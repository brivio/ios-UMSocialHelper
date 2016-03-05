#import "UMShareVC.h"
#import "UMShareCell.h"
#import "Extend.h"
#import "View+MASAdditions.h"
#import "UMPlatform.h"
#import "SDWebImageManager.h"

@implementation UMShareVC {
    UICollectionView *listCV;
    UIImage *shareImageRes;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    listCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:[UICollectionViewFlowLayout new]];
    [listCV registerNib:[UMShareCell class]];
    listCV.scrollEnabled = listCV.bounces = NO;
    listCV.dataSource = self;
    listCV.delegate = self;
    listCV.userInteractionEnabled = YES;
    listCV.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = _shareBGColor;
    [self.view addSubview:listCV];
    [listCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(8);
    }];
    [_controller.view showProgressHUD:@"加载中"];
    [SDWebImageManager.sharedManager
            downloadImageWithURL:[NSURL URLWithString:_shareImg]
                         options:0
                        progress:nil
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                           shareImageRes = image;
                           [_controller.view hideProgressHUD];
                           [listCV reloadData];
                       }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _platformList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UMShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UMShareCell className] forIndexPath:indexPath];
    cell.data = _platformList[(NSUInteger) indexPath.row];
    cell.shareContent = _shareContent;
    cell.shareImageRes = shareImageRes;
    cell.controller = _controller;
    [cell bind];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([UIScreen width] - 16 - 3) / 4, (200 - 1) / 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView highlight:indexPath color:_shareHoverColor];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView unHighlight:indexPath color:[UIColor clearColor]];
}


@end