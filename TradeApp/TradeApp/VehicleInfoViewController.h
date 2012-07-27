//
//  VehicleInfoViewController.h
//  TradeApp
//
//  Created by Helen Yang on 12-07-27.
//
//

#import <UIKit/UIKit.h>

@interface VehicleInfoViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *disclosures;
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *makes;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableArray *transmissions;

@end
