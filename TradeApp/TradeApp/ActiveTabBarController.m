//
//  ActiveTabBarController.m
//  TradeApp
//
//  Created by Helen on 12-07-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActiveTabBarController.h"
#import "ActiveViewController.h"
#import "ClosingViewController.h"

@interface ActiveTabBarController ()

@end

@implementation ActiveTabBarController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ActiveViewController *activeViewController = [[ActiveViewController alloc] init];
    UITabBarItem *sellTab = [[UITabBarItem alloc] initWithTitle:@"SELL" image:nil tag:1];
    [activeViewController setTabBarItem:sellTab];
    
    ClosingViewController *closingViewController = [[ClosingViewController alloc] init];
    UITabBarItem *buyTab = [[UITabBarItem alloc] initWithTitle:@"BUY" image:nil tag:1];
    [closingViewController setTabBarItem:buyTab];
    
    self.viewControllers = [NSMutableArray arrayWithObjects:activeViewController, closingViewController, nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
