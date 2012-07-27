//
//  SellAndBuyViewController.m
//  TradeApp
//
//  Created by Helen Yang on 12-07-27.
//
//

#import "SellAndBuyViewController.h"

@interface SellAndBuyViewController ()

@end

@implementation SellAndBuyViewController

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

//    NSLog(@"screen width = %f", [[UIScreen mainScreen] bounds].size.width);
    NSArray *list = [NSArray arrayWithObjects:@"Sell", @"Buy", nil];
    UISegmentedControl * segmentedControl = [[[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] initWithItems:list];
    segmentedControl.segmentedControlStyle = UISegmentedControlSegmentRight;
    segmentedControl.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [[UISegmentedControl appearance] setWidth:70 forSegmentAtIndex:0];
    [[UISegmentedControl appearance] setWidth:70 forSegmentAtIndex:1];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = segmentedControl;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma selector

- (void) switchTab:(id) sender 
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    if ([segmentedControl selectedSegmentIndex] == 0) // SELL
    {
        NSLog(@"Sell is clicked");
    } else // BUY
    {
        NSLog(@"Buy is clicked");
    }
}

@end
