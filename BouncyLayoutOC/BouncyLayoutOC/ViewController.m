//
//  ViewController.m
//  BouncyLayoutOC
//
//  Created by Heath on 28/04/2017.
//  Copyright © 2017 HeathWang. All rights reserved.
//

#import "ViewController.h"
#import "HWBouncyLayout.h"
#import "HWCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HWBouncyLayout *layout;

@end

@implementation ViewController

- (void)loadView {
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor whiteColor];
    self.view = view1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.layout = [HWBouncyLayout new];
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.itemSize = CGSizeMake(80, 80);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[HWCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.view addSubview:self.collectionView];
    self.collectionView.frame = [UIScreen mainScreen].bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 250;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HWCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    return collectionViewCell;
}


@end
