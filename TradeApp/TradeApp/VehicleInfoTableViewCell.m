//
//  VehicleInfoTableViewCell.m
//  TradeApp
//
//  Created by Helen Yang on 12-07-30.
//
//

#import "VehicleInfoTableViewCell.h"

@implementation VehicleInfoTableViewCell

@synthesize label, picker;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
