//
//  HWBouncyLayout.m
//  BouncyLayoutOC
//
//  Created by Heath on 28/04/2017.
//  Copyright © 2017 HeathWang. All rights reserved.
//

#import "HWBouncyLayout.h"

@interface HWBouncyLayout ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) CGFloat damping;
@property (nonatomic, assign) CGFloat frequency;

@end

@implementation HWBouncyLayout

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        _damping = 0.7;
        _frequency = 1.5;
    }
    return self;
}

- (instancetype)initWithDamping:(CGFloat)damping frequency:(CGFloat)frequency {
    self = [super init];
    if (self) {
        _damping = damping;
        _frequency = frequency;
    }
    return self;
}

- (instancetype)initWithStyle:(BouncyLayoutStyle)style {
    switch (style) {
        case BouncyLayoutStyleSubtle:
            return [self initWithDamping:1 frequency:2];
        case BouncyLayoutStyleRegular:
            return [self initWithDamping:0.7 frequency:1.5];
        case BouncyLayoutStyleProminent:
            return [self initWithDamping:0.5 frequency:1];
        default:
            break;
    }
}

#pragma mark - override

- (void)prepareLayout {
    [super prepareLayout];

    if (self.collectionView) {
        // call super method to get all attributes.
        NSArray *attributes = [[super layoutAttributesForElementsInRect:self.collectionView.bounds] copy];
        if (attributes) {
            NSArray *oldBehaviors = [self oldBehaviorsForAttributes:attributes];
            for (id oldBehavior in oldBehaviors) {
                [self.animator removeBehavior:oldBehavior];
            }

            
            NSArray *newBehaviors = [self newBehaviorsForAttributes:attributes];
            for (UIAttachmentBehavior *newBehavior in newBehaviors) {
                newBehavior.damping = self.damping;
                newBehavior.frequency = self.frequency;
                [self.animator addBehavior:newBehavior];
            }
        }
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return (NSArray<UICollectionViewLayoutAttributes *> *)[self.animator itemsInRect:rect];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    for (UIAttachmentBehavior *behavior in self.animator.behaviors) {
        if (self.collectionView && behavior.items.firstObject) {
            [self updateBehavior:behavior item:behavior.items.firstObject view:self.collectionView bounds:newBounds];
            [self.animator updateItemUsingCurrentState:behavior.items.firstObject];
        }
    }
    return NO;
}

#pragma mark - private method.

- (NSArray *)oldBehaviorsForAttributes:(NSArray *)attributes {

    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [indexPaths addObject:attribute.indexPath];
    }

    NSMutableArray *list = [NSMutableArray array];
    for (UIAttachmentBehavior *behavior in self.animator.behaviors) {
        id<UIDynamicItem> item = behavior.items.firstObject;
        if ([item isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            UICollectionViewLayoutAttributes *attributes1 = (UICollectionViewLayoutAttributes *)item;
            if (![indexPaths containsObject:attributes1.indexPath]) {
                [list addObject:behavior];
            }
        }
    }
    return list;
}

- (NSArray *)newBehaviorsForAttributes:(NSArray *)attributes {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.animator.behaviors.count];
    for (UIAttachmentBehavior *behavior in self.animator.behaviors) {
        UICollectionViewLayoutAttributes *attributes1 = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        [indexPaths addObject:attributes1.indexPath];
    }

    NSMutableArray *filterAttr = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (![indexPaths containsObject:attribute.indexPath]) {
            UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:attribute attachedToAnchor:attribute.center];
            [filterAttr addObject:attachmentBehavior];
        }
    }
    return filterAttr;
}

- (void)updateBehavior:(UIAttachmentBehavior *)behavior item:(id<UIDynamicItem>)item view:(UICollectionView *)collectionView bounds:(CGRect)bounds {

    CGVector delta = CGVectorMake(bounds.origin.x - collectionView.bounds.origin.x, bounds.origin.y - collectionView.bounds.origin.y);
    CGVector resistance = CGVectorMake(fabs([collectionView.panGestureRecognizer locationInView:collectionView].x - behavior.anchorPoint.x) / 1000, fabs([collectionView.panGestureRecognizer locationInView:collectionView].y - behavior.anchorPoint.y) / 1000);
    CGFloat x = (delta.dx < 0 ? MAX(delta.dx, delta.dx * resistance.dx) : MIN(delta.dx, delta.dx * resistance.dx)) + item.center.x;
    CGFloat y = (delta.dy < 0 ? MAX(delta.dy, delta.dy * resistance.dy) : MIN(delta.dy, delta.dy * resistance.dy)) + item.center.y;
    item.center = CGPointMake(x, y);
}

#pragma mark - Getter

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return _animator;
}


@end
