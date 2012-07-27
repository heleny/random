//
//  SellAndBuyViewController.m
//  TradeApp
//
//  Created by Helen Yang on 12-07-27.
//
//

#import "SellAndBuyViewController.h"

@interface SellAndBuyViewController ()
@property int currentSegmentId;
@end

@implementation SellAndBuyViewController

@synthesize sellViewController, buyViewController, currentSegmentId;

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

    NSArray *list = [NSArray arrayWithObjects:@"Sell", @"Buy", nil];
    UISegmentedControl * segmentedControl = [[[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] initWithItems:list];
    segmentedControl.segmentedControlStyle = UISegmentedControlSegmentRight;
    segmentedControl.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [[UISegmentedControl appearance] setWidth:70 forSegmentAtIndex:0];
    [[UISegmentedControl appearance] setWidth:70 forSegmentAtIndex:1];
    segmentedControl.selectedSegmentIndex = 0; // default is on SELL
    self.currentSegmentId = 0;
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = segmentedControl;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    }
    
    self.sellViewController = [[SellViewController alloc] init];
    self.buyViewController = [[BuyViewController alloc] init];
    [self.view addSubview:self.sellViewController.view];
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

- (void) segmentChanged:(id) sender 
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    int selectedIndex = [segmentedControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            if (self.currentSegmentId == 1)
                [self.buyViewController removeFromParentViewController];
            
            if (self.currentSegmentId != selectedIndex)
            {
                [self.view addSubview:self.sellViewController.view];
                self.currentSegmentId = [segmentedControl selectedSegmentIndex];
            }
            
            break;
        case 1:
            if (self.currentSegmentId == 0)
                [self.sellViewController removeFromParentViewController];
            
            if (self.currentSegmentId != selectedIndex)
            {
                [self.view addSubview:self.buyViewController.view];
                self.currentSegmentId = [segmentedControl selectedSegmentIndex];
            }

            break;
        default:
            break;
    }

}

@end
