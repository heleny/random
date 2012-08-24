//
//  CollapsableTableViewViewController.m
//  TradeApp
//
//  Created by Helen Yang on 12-08-17.
//
//

#import "CollapsableTableViewViewController.h"

@interface CollapsableTableViewViewController ()

@end

@implementation CollapsableTableViewViewController
@synthesize collapsableTableView = _collapsableTableView;

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
    self.collapsableTableView.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    }
}

- (void)viewDidUnload
{
    [self setCollapsableTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}


+ (NSString*) titleForHeaderForSection:(int) section
{
    switch (section)
    {
        case 0 : return @"First Section";
        case 1 : return @"Second Section";
        case 2 : return @"Third Section";
        case 3 : return @"Fourth Section";
        case 4 : return @"Fifth Section";
        default : return [NSString stringWithFormat:@"Section no. %i",section + 1];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [CollapsableTableViewViewController titleForHeaderForSection:section];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section== 2 ? 20 : 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    
    switch (indexPath.row)
    {
        case 0 : cell.textLabel.text = @"First Cell"; break;
        case 1 : cell.textLabel.text = @"Second Cell"; break;
        case 2 : cell.textLabel.text = @"Third Cell"; break;
        case 3 : cell.textLabel.text = @"Fourth Cell"; break;
        case 4 : cell.textLabel.text = @"Fifth Cell"; break;
        case 5 : cell.textLabel.text = @"Sixth Cell"; break;
        case 6 : cell.textLabel.text = @"Seventh Cell"; break;
        case 7 : cell.textLabel.text = @"Eighth Cell"; break;
        default : cell.textLabel.text = [NSString stringWithFormat:@"Cell %i",indexPath.row + 1];
    }
    
    //cell.detailTextLabel.text = ...;
    
    return cell;
}

#pragma mark - IBAction
- (IBAction)toggleSection2:(id)sender {
    NSString* sectionTitle = [CollapsableTableViewViewController titleForHeaderForSection:1];
    CollapsableTableView *collapsableTableView = (CollapsableTableView*) self.collapsableTableView;
    BOOL isCollapsed = [[collapsableTableView.headerTitleToIsCollapsedMap objectForKey:sectionTitle] boolValue];
    [collapsableTableView setIsCollapsed:! isCollapsed forHeaderWithTitle:sectionTitle];

}

@end
