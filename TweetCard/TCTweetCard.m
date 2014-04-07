//
//  TCTweetCard.m
//  TweetCard
//
//  Created by Triệu Khang on 27/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import "TCTweetCard.h"

#define getrandom(min, max) ((rand()%(int)(((max) + 1)-(min)))+ (min))

@interface TCTweetCard()
<
UIGestureRecognizerDelegate
>

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGFloat lastDx;
@property (assign, nonatomic) CGFloat lastDy;
@property (assign, nonatomic) BOOL isMoving;

@end

@implementation TCTweetCard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [self randomColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.layer.shouldRasterize = YES;
        
        UIPanGestureRecognizer *panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDragging:)];
        [self addGestureRecognizer:panGuesture];
    }
    return self;
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:getrandom(0, 255)/255.0 green:getrandom(0, 255)/255.0 blue:getrandom(0, 255)/255.0 alpha:0.8];
}

- (void)rotateTweetCardWithDuration:(CGFloat)time withDegree:(CGFloat)degree
{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeRotation(degree * M_PI / 180);
    }];
}

- (void)onDragging:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.currentPoint = [panGesture locationInView:self];
    }

    self.currentPoint = [panGesture locationInView:self];

    if (!self.isMoving) {
        if ([self.delegate respondsToSelector:@selector(tweetCardDidBeginMove:withPoint:)]) {
            [self.delegate tweetCardDidBeginMove:self withPoint:self.currentPoint];
        }
        self.isMoving = YES;
    }

    if (self.isMoving) {
        if([self.delegate respondsToSelector:@selector(tweetCardDidMove:withPoint:)]){
            [self.delegate tweetCardDidMove:self withPoint:self.currentPoint];
        }
    }

    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:2 animations:^{
            self.transform = CGAffineTransformTranslate(self.transform, self.width * self.lastDx, self.height * self.lastDy);
        } completion:^(BOOL finished) {
            [self finishMoveOut];
        }];

        if ([self.delegate respondsToSelector:@selector(tweetCardDidEndMove:)]) {
            [self.delegate tweetCardDidEndMove:self];
        }

        self.isMoving = NO;
    }
}

- (void)finishMoveOut
{
    if ([self.delegate respondsToSelector:@selector(tweetCardFinishMoveOutScreen)]) {
        [self.delegate performSelector:@selector(tweetCardFinishMoveOutScreen)];
    }
}

- (CGFloat)angleOfThisRotate
{
    return atan2(self.transform.b, self.transform.a) * 180 / M_PI;
}

@end
