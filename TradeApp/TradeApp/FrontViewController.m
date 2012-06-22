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
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
	UIViewController *stubController = [[UIViewController alloc] init];
	stubController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:stubController animated:YES];
}

@end
