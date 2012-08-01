//
//  VehicleInfoViewController.h
//  TradeApp
//
//  Created by Helen Yang on 12-07-27.
//
//

#import <UIKit/UIKit.h>
#import "VehicleInfo.h"

@interface VehicleInfoViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *disclosures;
@property (nonatomic, strong) NSMutableArray *options;

@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *makes;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableArray *vins;
@property (nonatomic, strong) NSMutableArray *transmissions;
@property (nonatomic, strong) UIPickerView *yearPicker;
@property (nonatomic, strong) UIPickerView *makePicker;
@property (nonatomic, strong) UIPickerView *modelPicker;
@property (nonatomic, strong) UIPickerView *vinPicker;
@property (nonatomic, strong) UIPickerView *transmissionPicker;
@property (nonatomic, strong) UIPickerView *currentActivePicker;
@property int selectedIndex;
@property (nonatomic, strong) UIView *masterView;

@property (nonatomic, strong) VehicleInfo *vehicleInfo;

- (CGSize)viewSize;

@end
