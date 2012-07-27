//
//  SellAndBuyViewController.h
//  TradeApp
//
//  Created by Helen Yang on 12-07-27.
//
//

#import <UIKit/UIKit.h>
#import "SellViewController.h"
#import "BuyViewController.h"

@interface SellAndBuyViewController : UIViewController

@property (nonatomic, strong) SellViewController *sellViewController;
@property (nonatomic, strong) BuyViewController *buyViewController;

@end
