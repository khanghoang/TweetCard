//
//  TCTweetCardViewController.m
//  TweetCard
//
//  Created by Triệu Khang on 27/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import "TCTweetCardViewController.h"
#import "TCTweetCard.h"

static CGFloat const BEGIN_DEGREE = 70;

@interface TCTweetCardViewController ()
<
TCTweetCardDelegate
>

@property (strong, nonatomic) NSMutableArray *tweetCards;
@property (assign, nonatomic) CGAffineTransform firstTweetCardAffine;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;

@end

@implementation TCTweetCardViewController

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }

    return _animator;
}

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] initWithItems:@[]];
    }

    return _gravity;
}

- (NSArray *)tweetCards
{
    if (!_tweetCards) {
        _tweetCards = [NSMutableArray array];
    }
    
    return _tweetCards;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    for (int i=0; i<7; i++) {
        TCTweetCard *tweetCard = [[TCTweetCard alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
        tweetCard.delegate = self;
        [tweetCard alignVerticallyCenterToView:self.view];
        [tweetCard alignHorizontalCenterToView:self.view];
        [tweetCard rotateTweetCardWithDuration:0 withDegree:BEGIN_DEGREE];
        [tweetCard rotateTweetCardWithDuration:0.5 + 0.1 * i withDegree: BEGIN_DEGREE + 140/8 * i];
        [self.view addSubview:tweetCard];
        
        if (i == 0) {
            self.firstTweetCardAffine = tweetCard.transform;
        }
        
        [self.tweetCards addObject:tweetCard];
    }

    [self.animator addBehavior:self.gravity];
}

#pragma mark - TweetCard delegate
- (void)tweetCardFinishMoveOutScreen
{
    for (int i=0; i<6; i++) {
        TCTweetCard *tweetCard = [self.tweetCards objectAtIndex:i];
        tweetCard.delegate = self;
        [tweetCard alignVerticallyCenterToView:self.view];
        [tweetCard alignHorizontalCenterToView:self.view];
        CGFloat degree = [tweetCard angleOfThisRotate] + 140/8;
        [tweetCard rotateTweetCardWithDuration:0.5 + 0.1 * i withDegree:degree];
        [self.view addSubview:tweetCard];
    }
    
    [self swapTweetCardFromLastToFirst];
    [self restoreMovedOutTweetCard:[self.tweetCards firstObject]];
}

- (void)swapTweetCardFromLastToFirst
{
    TCTweetCard *tweetCard = [self.tweetCards objectAtIndex:self.tweetCards.count - 1];
    [self.tweetCards removeObject:tweetCard];
    [self.tweetCards insertObject:tweetCard atIndex:0];
}

- (void)restoreMovedOutTweetCard:(TCTweetCard *)tweetCard
{
    [UIView animateWithDuration:2 animations:^{
        tweetCard.transform = self.firstTweetCardAffine;
    }];
}

- (void)tweetCardDidBeginMove:(TCTweetCard *)tweetCard withPoint:(CGPoint)point
{
    CGPoint newPoint = [tweetCard convertPoint:point toView:self.view];

    UIOffset offset = UIOffsetMake(point.x - tweetCard.bounds.size.width/2, point.y - tweetCard.bounds.size.height/2);
    self.attachment = [[UIAttachmentBehavior alloc] initWithItem:tweetCard
                                                offsetFromCenter:offset
                                                attachedToAnchor:newPoint];
    [self.animator addBehavior:self.attachment];
    [self.gravity addItem:tweetCard];
    DLog(@"Tweet card begin  %@", NSStringFromCGPoint(newPoint));
}

- (void)tweetCardDidMove:(TCTweetCard *)tweetCard withPoint:(CGPoint)point
{
    CGPoint newPoint = [tweetCard convertPoint:point toView:self.view];
    DLog(@"Tweet card has moved %@", NSStringFromCGPoint(newPoint));
    self.attachment.anchorPoint = newPoint;
}

- (void)tweetCardDidEndMove:(TCTweetCard *)tweetCard
{
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:self.gravity];

    [tweetCard addObserver:self forKeyPath:@"tweetCard" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    TCTweetCard *card = (TCTweetCard *)object;
    CGRect animation = [[card.layer presentationLayer] frame];
    CGFloat y = CGRectGetMinY(animation);
    NSLog(@"Rect = %@", NSStringFromCGRect(animation));
    NSLog(@"Min Y is : %f", y);
    if ( y >= 568) {
        NSLog(@"Card out of screen");
    }
}

- (void)animationCardToTheGroup:(TCTweetCard *)tweetCard
{
    [self.gravity removeItem:tweetCard];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:tweetCard
                                                    snapToPoint:CGPointMake(160, 284)];
    snap.damping = 1.0;
    [self.animator addBehavior:snap];
}

- (void)tweetCardFinishMoveOutScreen:(TCTweetCard *)tweetCard
{
    [self animationCardToTheGroup:tweetCard];
}

@end
