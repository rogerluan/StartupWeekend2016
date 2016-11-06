//
//  OrderDetailsViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderConfirmedViewController.h"

@interface OrderDetailsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UILabel *rewardLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.minimumDate = [NSDate date];
}

#pragma mark - IBAction -

- (IBAction)didStep:(UIStepper *)sender {
    self.rewardLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
}

- (IBAction)didRequestOrder:(UIButton *)sender {
    if (NO) {
        //to-do: validade fields
        return;
    }
    //to-do: update self.order;
    [self performSegueWithIdentifier:@"RequestOrderSegueIdentifier" sender:self];
}

#pragma mark - Navigation - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RequestOrderSegueIdentifier"]) {
        OrderConfirmedViewController *vc = (OrderConfirmedViewController *)segue.destinationViewController;
        vc.order = self.order;
    }
}

@end
