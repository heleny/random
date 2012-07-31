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
    
//    NSLog(@"Screen size (width, height) = (%f, %f)", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

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
    transmissions = [NSMutableArray arrayWithObjects:@"Automatic", @"Hybrid", @"Manual", nil];

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
    UILabel *secondaryLabel;
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        secondaryLabel = [[UILabel alloc] init];
        secondaryLabel.textAlignment = UITextAlignmentRight;
        secondaryLabel.backgroundColor = [UIColor clearColor];
        secondaryLabel.textColor = [UIColor blackColor];
        secondaryLabel.tag = 123;
        [cell.contentView addSubview:secondaryLabel];
	}
	
    if (indexPath.section == 0) {
        cell.textLabel.text = [disclosures objectAtIndex:indexPath.row];
        
        secondaryLabel = (UILabel *)[cell.contentView viewWithTag:123];
        secondaryLabel.frame = CGRectMake(cell.frame.size.width - 150, cell.textLabel.frame.origin.y, 100, cell.textLabel.frame.size.height);
        if (indexPath.row == 0)
			secondaryLabel.text = self.selectedYear;
		else if (indexPath.row == 1)
			secondaryLabel.text = self.selectedMake;
		else if (indexPath.row == 2)
			secondaryLabel.text = self.selectedModel;
		else if (indexPath.row == 4)
			secondaryLabel.text = self.selectedTransmission;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [options objectAtIndex:indexPath.row];
    }
    
	cell.textLabel.textColor = [UIColor purpleColor];

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
    if (indexPath.section == 0) {
        if (self.currentActivePicker) {
            [self.currentActivePicker removeFromSuperview];
        }
        switch (indexPath.row) {
            case 0:
                [self.masterView addSubview:self.yearPicker];
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.masterView];
                break;
            case 1:
                [self.masterView addSubview:self.makePicker];
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.masterView];
                break;
            case 2:
                [self.masterView addSubview:self.modelPicker];
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.masterView];
                break;
            case 3:
                NSLog(@"************** VIN row is selected");
                break;
            case 4:
                [self.masterView addSubview:self.transmissionPicker];
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.masterView];
                break;
                                           
            default:
                break;
        }
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (thePickerView == self.yearPicker)
        return [years count];
	else if (thePickerView == self.makePicker)
		return [makes count];
	else if (thePickerView == self.modelPicker)
		return [models count];
	else if (thePickerView == self.transmissionPicker)
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
}

- (void)actionPickerDone: (id) sender
{
    [self.masterView removeFromSuperview];
	if (self.currentActivePicker == self.yearPicker) {
    	self.selectedYear = [self.years objectAtIndex:[self.yearPicker selectedRowInComponent:0]];
    }
	else if (self.currentActivePicker == self.makePicker) {
		self.selectedMake = [self.makes objectAtIndex:[self.makePicker selectedRowInComponent:0]];
    }
	else if (self.currentActivePicker == self.modelPicker) {
		self.selectedModel = [self.models objectAtIndex:[self.modelPicker selectedRowInComponent:0]];
    }
	else if (self.currentActivePicker == self.transmissionPicker) {
		self.selectedTransmission = [self.transmissions objectAtIndex:[self.transmissionPicker selectedRowInComponent:0]];
    }

    [self.tableView reloadData];
}




@end
