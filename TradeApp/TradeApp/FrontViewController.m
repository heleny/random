//
//  FrontViewController.m
//  TradeApp
//
//  Created by Helen on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FrontViewController.h"

@interface FrontViewController ()

@end

@implementation FrontViewController

@synthesize activeList, closingList, wonList, lostList, arrivedList, deliveredList;


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"Front View", @"FrontView");
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
	}
    
	
	NSLog(@"screen width = %f    height = %f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIButton *pushMe = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 40, 100, 20)];
    [pushMe setTitle:@"push me" forState:UIControlStateNormal];
    [pushMe addTarget:self action:@selector(pushExample:) forControlEvents:UIControlEventTouchUpInside];
	pushMe.titleLabel.textColor = [UIColor yellowColor];
	pushMe.backgroundColor = [UIColor redColor];

    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 120)];
    [text setText:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."];
	text.lineBreakMode = UILineBreakModeWordWrap;
	text.numberOfLines = 10;

	[self.view addSubview:pushMe]; 	
	[self.view addSubview:text];
	self.view.backgroundColor = [UIColor whiteColor];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.activeList = nil;
    self.closingList = nil;
    self.wonList = nil;
    self.lostList = nil;
    self.arrivedList = nil;
    self.deliveredList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - selector

- (void)pushExample:(id)sender
{
	UIViewController *stubController = [[UIViewController alloc] init];
	stubController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:stubController animated:YES];
}

@end
