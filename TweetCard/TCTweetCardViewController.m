//
//  TCTweetCardViewController.m
//  TweetCard
//
//  Created by Triệu Khang on 27/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import "TCTweetCardViewController.h"

#define getrandom(min, max) ((rand()%(int)(((max) + 1)-(min)))+ (min))

@interface TCTweetCardViewController ()

@end

@implementation TCTweetCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *tweetCard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    [tweetCard alignHorizontalCenterToView:self.view];
    [tweetCard alignVerticallyCenterToView:self.view];
    tweetCard.backgroundColor = [self randomColor];
    [self.view addSubview:tweetCard];
    
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:getrandom(0, 255)/255.0 green:getrandom(0, 255)/255.0 blue:getrandom(0, 255)/255.0 alpha:1.0];
}
@end
