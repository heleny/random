//
//  RadioButtonView.h
//  TradeApp
//
//  Created by Helen Yang on 12-07-26.
//
//

#import <UIKit/UIKit.h>

@interface RadioButtonView : UIView

@property (nonatomic, retain) NSMutableArray *radioButtons;

- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options andColumns:(int)columns;
-(IBAction) radioButtonClicked:(UIButton *) sender;
-(void) removeButtonAtIndex:(int)index;
-(void) setSelected:(int) index;
-(void)clearAll;

@end
