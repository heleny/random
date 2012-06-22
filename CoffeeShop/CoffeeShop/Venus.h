//
//  Venus.h
//  CoffeeShop
//
//  Created by Helen on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Stats.h"

@interface Venus : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Stats *stats;

@end
