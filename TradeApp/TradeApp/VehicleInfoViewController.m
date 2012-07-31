//
//  VehicleInfoViewController.m
//  TradeApp
//
//  Created by Helen Yang on 12-07-27.
//
//

#import "VehicleInfoViewController.h"

#define WIDTH 320.0f
#define HEIGHT 480.0f

@interface VehicleInfoViewController ()
@property (nonatomic, weak) NSString *selectedYear;
@property (nonatomic, weak) NSString *selectedMake;
@property (nonatomic, weak) NSString *selectedModel;
@property (nonatomic, weak) NSString *selectedTransmission;
@end

@implementation VehicleInfoViewController

@synthesize disclosures, options, years, makes, models, transmissions, yearPicker, makePicker, modelPicker, transmissionPicker, selectedIndex, masterView, selectedYear, selectedMake, selectedModel, selectedTransmission, currentActivePicker;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Screen size (width, height) = (%f, %f)", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

    self.title = @"Vehicle Info";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    disclosures = [NSMutableArray arrayWithObjects:@"Year", @"Make", @"Model", @"VIN", @"Transmission", nil]; // disclosures
    options = [NSMutableArray arrayWithObjects:@"Sunroof", @"Alloy Wheels", @"Snow Tires", @"Heated Seats", @"Leather", nil]; // options
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    }
    
    years = [NSMutableArray arrayWithObjects:@"2012", @"2011", @"2010", @"2009", @"2008", @"2007", @"2006", @"2005", @"2004", @"2003", @"2002", @"2001", @"2000", @"1999", @"1998", @"1997",nil];
    makes = [NSMutableArray arrayWithObjects:@"Acura", @"Audi", @"BMW", @"Chevrolet", @"Chrysler", @"Ford", @"Honda", @"Hyundai", @"Jeep", @"Mazda", @"Mercedes-Benz", @"Nissan", @"Porsche", @"Saturn", @"Subaru", @"Toyota", @"Volkswagen", @"Volvo", nil];
    models = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", nil];
    transmissions = [NSMutableArray arrayWithObjects:@"Automatic", @"Manual", nil];

    masterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewSize.height/2, self.viewSize.width, 260)];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [pickerToolbar setItems:[NSArray arrayWithObjects:cancel, space, done, nil] animated:YES];
    
    
    [masterView addSubview:pickerToolbar];

    CGRect rect = CGRectMake(0, 40, self.viewSize.width, 216);
    self.yearPicker = [[UIPickerView alloc] init];
    self.yearPicker.dataSource = self;
    self.yearPicker.delegate = self;
    self.yearPicker.frame = rect;
    self.yearPicker.showsSelectionIndicator = YES;
    [self.yearPicker selectRow:self.selectedIndex inComponent:0 animated:YES];
    [masterView addSubview:self.yearPicker];
    
    self.makePicker = [[UIPickerView alloc] init];
    self.makePicker.dataSource = self;
    self.makePicker.delegate = self;
    self.makePicker.frame = rect;
    self.makePicker.showsSelectionIndicator = YES;
    
    self.modelPicker = [[UIPickerView alloc] init];
    self.modelPicker.dataSource = self;
    self.modelPicker.delegate = self;
    self.modelPicker.frame = rect;
    self.modelPicker.showsSelectionIndicator = YES;
    
    self.transmissionPicker = [[UIPickerView alloc] init];
    self.transmissionPicker.dataSource = self;
    self.transmissionPicker.delegate = self;
    self.transmissionPicker.frame = rect;
    self.transmissionPicker.showsSelectionIndicator = YES;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.disclosures = nil;
    self.options = nil;
    self.years = nil;
    self.makes = nil;
    self.models = nil;
    self.transmissions = nil;
    self.yearPicker = nil;
    self.makePicker = nil;
    self.modelPicker = nil;
    self.transmissionPicker = nil;
    self.masterView = nil;
    self.selectedYear = nil;
    self.selectedMake = nil;
    self.selectedModel = nil;
    self.selectedTransmission = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Disclosures";
    else
        return @"Options";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.disclosures count];
    else if (section == 1)
        return [self.options count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [disclosures objectAtIndex:indexPath.row];

		CGRect frame = cell.textLabel.frame;
		UILabel *secondary = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 210, frame.origin.y, frame.size.width + 20, frame.size.height)];
		secondary.textAlignment = UITextAlignmentRight;
		secondary.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:secondary];
		if (self.selectedYear && indexPath.row == 0)
			secondary.text = self.selectedYear;
		else if (selectedMake && indexPath.row == 1)
			secondary.text = self.selectedMake;
		else if (selectedModel && indexPath.row == 2)
			secondary.text = self.selectedModel;
		else if (selectedTransmission && indexPath.row == 4)
			secondary.text = self.selectedTransmission;
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [options objectAtIndex:indexPath.row];
    }
    
	cell.textLabel.textColor = [UIColor purpleColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.row == 0)
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.masterView];
		
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (thePickerView == yearPicker)
        return [years count];
	else if (thePickerView == makePicker)
		return [makes count];
	else if (thePickerView == modelPicker)
		return [models count];
	else if (thePickerView == transmissionPicker)
		return [transmissions count];

    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (thePickerView == yearPicker)
        return [years objectAtIndex:row];
	else if (thePickerView == makePicker)
		return [makes objectAtIndex:row];
	else if (thePickerView == modelPicker)
		return [models objectAtIndex:row];
	else if (thePickerView == transmissionPicker)
		return [transmissions objectAtIndex:row];
    return 0;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.currentActivePicker = thePickerView;
    if (thePickerView == yearPicker)
        NSLog(@"Selected year: %@", [years objectAtIndex:row]);
	else if (thePickerView == makePicker)
		NSLog(@"Selected make: %@", [makes objectAtIndex:row]);
	else if (thePickerView == modelPicker)
		NSLog(@"Selected model: %@", [models objectAtIndex:row]);
	else if (thePickerView == transmissionPicker)
		NSLog(@"Selected transmission: %@", [transmissions objectAtIndex:row]);
}

#pragma mark - utilities


- (CGSize)viewSize {
    if (!(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)))
        return CGSizeMake(480, 320);
    return CGSizeMake(320, 480);
}

#pragma mark - Selector

- (void)actionPickerCancel: (id) sender
{
    [self.masterView removeFromSuperview];
    NSLog(@"User pressed cancel button");
}

- (void)actionPickerDone: (id) sender
{
    [self.masterView removeFromSuperview];
	if (self.currentActivePicker == self.yearPicker)
    	self.selectedYear = [years objectAtIndex:[yearPicker selectedRowInComponent:0]];
	else if (self.currentActivePicker == self.makePicker)
		self.selectedMake = [makes objectAtIndex:[makePicker selectedRowInComponent:0]];
	else if (self.currentActivePicker = self.modelPicker)
		self.selectedModel = [models objectAtIndex:[modelPicker selectedRowInComponent:0]];
	else if (self.currentActivePicker == self.transmissionPicker)
		self.selectedTransmission = [transmissions objectAtIndex:[transmissionPicker selectedRowInComponent:0]];
    [self.tableView reloadData];
}




@end
