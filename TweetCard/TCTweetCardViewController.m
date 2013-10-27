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

@end

@implementation TCTweetCardViewController

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
        
        [self.tweetCards addObject:tweetCard];
    }

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
}

- (void)swapTweetCardFromLastToFirst
{
    TCTweetCard *tweetCard = [self.tweetCards objectAtIndex:self.tweetCards.count - 1];
    [self.tweetCards removeObject:tweetCard];
    [self.tweetCards insertObject:tweetCard atIndex:0];
}

- (void)restoreMovedOutTweetCard:(TCTweetCard *)tweetCard
{
    
}

@end
