//
//  TCTweetCard.h
//  TweetCard
//
//  Created by Triệu Khang on 27/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCTweetCardDelegate <NSObject>

- (void)tweetCardFinishMoveOutScreen;

@end

@interface TCTweetCard : UIView

@property (strong, nonatomic) id<TCTweetCardDelegate> delegate;

- (void)rotateTweetCardWithDuration:(CGFloat)time withDegree:(CGFloat)degree;
- (CGFloat)angleOfThisRotate;

@end
