//
//  VehicleInfo.h
//  TradeApp
//
//  Created by Helen Yang on 12-07-31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VehicleInfo : NSManagedObject

@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * transmission;
@property (nonatomic, retain) NSString * vin;

@end
