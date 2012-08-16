//
//  LiveChatViewController.h
//  TradeApp
//
//  Created by Helen Yang on 12-08-16.
//
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

@interface LiveChatViewController : UIViewController <UIBubbleTableViewDataSource>

@property (strong, nonatomic) IBOutlet UIBubbleTableView *bubbleTableView;
@property (nonatomic, strong) NSMutableArray *bubbleData;

@end
