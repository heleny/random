//
//  MasterViewController.m
//  CoffeeShop
//
//  Created by Helen on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Venus.h"
#import "VenusCell.h"


#define kCLIENTID "ZR3B5JWX5X44X4ECSWLFYFQNLBW21B1OSYODSCVJWTXQ4YIT"
#define kCLIENTSECRET "MA004KB1CVZIWNWW3J4HBCDYCXC3Z04AWD0GXFSTLILZVZ4K"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize data;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    RKURL *baseUrl = [RKURL URLWithBaseURLString:@"https://api.Foursquare.com/v2"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseUrl];
    objectManager.client.baseURL = baseUrl;
    
    // Venus.name
    RKObjectMapping *venusMapping = [RKObjectMapping mappingForClass:[Venus class]];
    [venusMapping mapKeyPathsToAttributes:@"name", @"name", nil];
    [objectManager.mappingProvider setMapping:venusMapping forKeyPath:@"response.venues"];
    
    // Location
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping mapKeyPathsToAttributes:@"address", @"address", @"city", @"city", @"country", @"country", @"crossStreet", @"crossStreet", @"postalCode", @"postalCode", @"state", @"state", @"distance", @"distance", @"lat", @"lat", @"lng", @"lng", nil];
    
    [venusMapping mapRelationship:@"location" withMapping:locationMapping];
    [objectManager.mappingProvider setMapping:locationMapping forKeyPath:@"location"];
    
    
    // Stats
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping mapKeyPathsToAttributes:@"checkinsCount", @"checkins", @"tipCount", @"tips", @"usersCount", @"users", nil];
    [venusMapping mapRelationship:@"stats" withMapping:statsMapping];
    [objectManager.mappingProvider setMapping:statsMapping forKeyPath:@"stats"];
    
    [self sendRequest];
    
    
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) sendRequest {
    NSString *latLon = @"37.33,-122.03";
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:latLon, @"ll", clientID, @"client_id", clientSecret, @"client_secret", @"coffee", @"query", @"20120602", @"v", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/venues/search" queryParameters:queryParams];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return _objects.count;
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    // UITableViewCell
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    cell.textLabel.text = [venus.name length] > 24 ? [venus.name substringToIndex:24] : venus.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", [venus.location.distance floatValue]];

    // VenusCell
    VenusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Venus *venus = [data objectAtIndex:indexPath.row];    
    cell.nameLabel.text = [venus.name length] > 25 ? [venus.name substringToIndex:25] : venus.name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", [venus.location.distance floatValue]];
    cell.checkinsLabel.text = [NSString stringWithFormat:@"%d checkins", [venus.stats.checkins intValue]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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


/*
 prepares the Master view to display the Detail view. Segues are used to control movement between view controllers, and are a feature of Storyboards. For more on Storyboards, see Beginning Storyboards in iOS 5 for an excellent introduction.
 */
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = [_objects objectAtIndex:indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    
//    for (int i = 0; i < [objects count]; i++) {
//        Venus *venus = [objects objectAtIndex:i];
//        NSLog(@"location %d: %@", i, venus.location.distance);
//    }
    data = objects;
    
    [self.tableView reloadData];
}

@end
