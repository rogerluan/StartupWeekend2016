//
//  OrderBoughtViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrderBoughtViewController.h"

@interface OrderBoughtViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation OrderBoughtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressLabel.text = self.order.address;
}

- (IBAction)openMapsTapped:(UIButton *)sender {
    NSString *directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=Current%%20Location&daddr=%@", self.order.address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:directionsURL]];
}

@end
