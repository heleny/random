//
//  RearViewControllerViewController.m
//  TradeApp
//
//  Created by Helen on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RearViewController.h"
#import "FrontViewController.h"
#import "TradeAppViewController.h"
#import "ClosingViewController.h"
#import "WonViewController.h"
#import "ActiveViewcontroller.h"

@interface RearViewController ()

@end

@implementation RearViewController

@synthesize states;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    states = [NSArray arrayWithObjects:@"Active", @"Closing", @"Won", @"Lost", @"Arrived", @"Delivered", nil];
    states = [NSArray arrayWithObjects:@"Active", @"Closing", @"Won", nil];
//	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width/2, self.view.frame.size.height);
//	self.view.backgroundColor = [UIColor clearColor];
	
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [states count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSeparatorStyleSingleLine reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [states objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
	TradeAppViewController *tradeAppViewController = [self.parentViewController isKindOfClass:[TradeAppViewController class]] ? (TradeAppViewController *)self.parentViewController : nil;
    
	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	//	if (indexPath.row == 0)
	//	{
	//		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
	//		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[FrontViewController class]])
	//		{
	//			FrontViewController *frontViewController = [[FrontViewController alloc] init];
	//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
	//			[tradeAppViewController setFrontViewController:navigationController animated:NO];
	//			
	//		}
	//		// Seems the user attempts to 'switch' to exactly the same controller he came from!
	//		else
	//		{
	//			[tradeAppViewController revealToggle:self];
	//		}
	//	}
	if (indexPath.row == 0)
		{
			// Now let's see if we're not attempting to swap the current ActiveViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[ActiveViewController class]])
			{
			ActiveViewController *activeViewController = [[ActiveViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activeViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
			
			}
			// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
			{
			[tradeAppViewController revealToggle:self];
			}
		}
	// ... and the second row (=1) corresponds to the "MapViewController".
	else if (indexPath.row == 1)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[ClosingViewController class]])
		{
			ClosingViewController *closingViewController = [[ClosingViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:closingViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[tradeAppViewController revealToggle:self];
		}
	}
	else if (indexPath.row == 2)
	{
		
		NSLog(@"third row is clicked");
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[WonViewController class]])
		{
			WonViewController *wonViewController = [[WonViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wonViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[tradeAppViewController revealToggle:self];
		}
	}
	else if (indexPath.row == 3)
	{
		[tradeAppViewController showFrontViewCompletely:NO];
	}
}

@end
