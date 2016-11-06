//
//  OrderConfirmedViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrderConfirmedViewController.h"
#import "ReviewViewController.h"

@interface OrderConfirmedViewController ()

@end

@implementation OrderConfirmedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didReceive:(UIButton *)sender {
    //to-do: update order status as received?
    [self performSegueWithIdentifier:@"ReceiveOrderSegueIdentifier" sender:self];
}

#pragma mark - Navigation - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ReceiveOrderSegueIdentifier"]) {
        ReviewViewController *vc = (ReviewViewController *)segue.destinationViewController;
        vc.order = self.order;
    }
}

@end
