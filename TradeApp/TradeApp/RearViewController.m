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
#import "ActiveTabBarController.h"
#import "RadioButtonsViewController.h"
#import "VehicleInfoViewController.h"
#import "SellAndBuyViewController.h"
#import "ImageViewController.h"
#import "LiveChatViewController.h"
#import "CollapsableTableViewViewController.h"

@interface RearViewController ()

@end

@implementation RearViewController

@synthesize states = _states;

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

    self.states = [NSArray arrayWithObjects:@"Active", @"Closing", @"Won", @"Buy & Sell", @"Vehicle Info", @"Radio Buttons", @"Images", @"Live Chat", @"CollapsableTableView", nil];
	self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.states = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"States";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.states count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSeparatorStyleSingleLine reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.states objectAtIndex:indexPath.row];
    
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
    
	// FrontViewController
    // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	//	if (indexPath.row == 0)
	//	{
	//		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[FrontViewController class]])
	//		{
	//			FrontViewController *frontViewController = [[FrontViewController alloc] init];
	//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
	//			[tradeAppViewController setFrontViewController:navigationController animated:NO];
	//		}
	//		else
	//		{
	//			[tradeAppViewController revealToggle:self];
	//		}
	//	}
    
    
	if (indexPath.row == 0) {
        NSLog(@"Active is clicked");
        // FrontViewController
//        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[FrontViewController class]]) {
//                FrontViewController *frontViewController = [[FrontViewController alloc] init];
        
        // ActiveViewController
		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[ActiveViewController class]]) {
                ActiveViewController *activeViewController = [[ActiveViewController alloc] init];
            
//        // ActiveTabBarController
//        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[ActiveTabBarController class]]) {
//                ActiveTabBarController *activeTabBarController = [[ActiveTabBarController alloc] init];    
    
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activeViewController];
                [tradeAppViewController setFrontViewController:navigationController animated:NO];
			}
		else {
			[tradeAppViewController revealToggle:self];
        }
    }
	// ... and the second row (=1) corresponds to the "MapViewController".
	else if (indexPath.row == 1) {
        NSLog(@"Closing is clicked");
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[ClosingViewController class]]) {
			ClosingViewController *closingViewController = [[ClosingViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:closingViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
        else {
			[tradeAppViewController revealToggle:self];
		}
	}
	else if (indexPath.row == 2) {
        NSLog(@"Won is clicked");
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[WonViewController class]]) {
			WonViewController *wonViewController = [[WonViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wonViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else {
			[tradeAppViewController revealToggle:self];
		}
	}
    else if (indexPath.row == 3) {
        NSLog(@"Sell & Buy is clicked");
        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[SellAndBuyViewController class]]) {
			SellAndBuyViewController *sellAndBuyViewController = [[SellAndBuyViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sellAndBuyViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		else {
			[tradeAppViewController revealToggle:self];
		}
    }

    else if (indexPath.row == 4) {
        NSLog(@"Vehicle Info is clicked");
        // RadioButtonsViewController
//        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[RadioButtonsViewController class]])
//		{
//			RadioButtonsViewController *radioButtonsViewController = [[RadioButtonsViewController alloc] init];
//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:radioButtonsViewController];
//			[tradeAppViewController setFrontViewController:navigationController animated:NO];
//		}
        
        //VehicleInfoViewController
        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[VehicleInfoViewController class]]) {
			VehicleInfoViewController *vehicleInfoViewController = [[VehicleInfoViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vehicleInfoViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		else {
			[tradeAppViewController revealToggle:self];
		}
    }
    else if (indexPath.row == 5) {
        NSLog(@"Radio Buttons is clicked");
        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[RadioButtonsViewController class]]) {
			RadioButtonsViewController *radioButtonsViewController = [[RadioButtonsViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:radioButtonsViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		else {
			[tradeAppViewController revealToggle:self];
		}
    }
    else if (indexPath.row == 6) {
        NSLog(@"Image is clicked");
        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[ImageViewController class]]) {
			ImageViewController *imageViewController = [[ImageViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		else {
			[tradeAppViewController revealToggle:self];
		}
    }
    else if (indexPath.row == 7) {
        NSLog(@"Live Chat is clicked");
        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[LiveChatViewController class]]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LiveChat" bundle: nil];
            LiveChatViewController *liveChatViewController = [storyboard instantiateInitialViewController];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:liveChatViewController];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		else {
			[tradeAppViewController revealToggle:self];
		}
    }
    else if (indexPath.row == 8) {
        NSLog(@"CollapsableTableView is clicked");
        if ([tradeAppViewController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)tradeAppViewController.frontViewController).topViewController isKindOfClass:[CollapsableTableViewViewController class]]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CollapsableTableView" bundle: nil];
            CollapsableTableViewViewController *collapsableTableView = [storyboard instantiateInitialViewController];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:collapsableTableView];
			[tradeAppViewController setFrontViewController:navigationController animated:NO];
		}
		else {
			[tradeAppViewController revealToggle:self];
		}
    }
	else if (indexPath.row == 9) {
		[tradeAppViewController showFrontViewCompletely:NO];
	}
}

@end
