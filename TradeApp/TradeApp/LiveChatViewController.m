//
//  LiveChatViewController.m
//  TradeApp
//
//  Created by Helen Yang on 12-08-16.
//
//

#import "LiveChatViewController.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"

@interface LiveChatViewController ()

@end

@implementation LiveChatViewController

@synthesize bubbleTableView;
@synthesize bubbleData;

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
    bubbleTableView.backgroundColor = [UIColor lightTextColor];
    bubbleTableView.bubbleDataSource = self;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:
                 [NSBubbleData dataWithText:@"Hi Winters, how have you been.  Long time no see." andDate:[NSDate dateWithTimeIntervalSinceNow:-300] andType:BubbleTypeMine],
                 [NSBubbleData dataWithText:@"I'm very well.  Thank you.  How are you doing?" andDate:[NSDate dateWithTimeIntervalSinceNow:-280] andType:BubbleTypeSomeoneElse],
                 [NSBubbleData dataWithText:@"I'm doing fine except that I ..." andDate:[NSDate dateWithTimeIntervalSinceNow:0] andType:BubbleTypeMine],
                 [NSBubbleData dataWithText:@"Oh, what's wrong?" andDate:[NSDate dateWithTimeIntervalSinceNow:300] andType:BubbleTypeSomeoneElse],
                 [NSBubbleData dataWithText:@"I have wrote down what I wanted to say on a card." andDate:[NSDate dateWithTimeIntervalSinceNow:395] andType:BubbleTypeMine],
                 [NSBubbleData dataWithText:@"The stupid thing must have fallen out of my pocket." andDate:[NSDate dateWithTimeIntervalSinceNow:400] andType:BubbleTypeMine],
                  nil];
                  
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    }
    
}

- (void)viewDidUnload
{
    [self setBubbleTableView:nil];
    [self setBubbleData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}


@end
