//
//  TCTweetCard.h
//  TweetCard
//
//  Created by Triệu Khang on 27/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCTweetCard;

@protocol TCTweetCardDelegate <NSObject>

- (void)tweetCardDidBeginMove:(TCTweetCard *)tweetCard withPoint:(CGPoint)point;
- (void)tweetCardDidMove:(TCTweetCard *)tweetCard withPoint:(CGPoint)point;
- (void)tweetCardDidEndMove:(TCTweetCard *)tweetCard;
- (void)tweetCardFinishMoveOutScreen;

@end

@interface TCTweetCard : UIView

@property (strong, nonatomic) id<TCTweetCardDelegate> delegate;
@property (assign, nonatomic) CGPoint currentPoint;

- (void)backToTheGroupWithCurrentPanPosition:(CGPoint)currentPoint;

- (void)rotateTweetCardWithDuration:(CGFloat)time withDegree:(CGFloat)degree;
- (CGFloat)angleOfThisRotate;

@end
