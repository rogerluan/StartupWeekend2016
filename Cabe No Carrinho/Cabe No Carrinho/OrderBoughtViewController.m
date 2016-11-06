//
//  OrderBoughtViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrderBoughtViewController.h"
#import "ReviewViewController.h"

static NSString * const DeliverOrderSegueIdentifier = @"DeliverOrderSegueIdentifier";

@interface OrderBoughtViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation OrderBoughtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressLabel.text = self.order.address;
}

- (IBAction)openMapsTapped:(UIButton *)sender {
    NSString *directionsURL = [NSString stringWithFormat:@"https://maps.apple.com/?saddr=Current%%20Location&daddr=%@", self.order.address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:directionsURL]];
}

- (IBAction)deliveredButton:(id)sender {
    [self performSegueWithIdentifier:DeliverOrderSegueIdentifier sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DeliverOrderSegueIdentifier]) {
        ReviewViewController *vc = (ReviewViewController *)segue.destinationViewController;
        vc.order = self.order;
    }
}

@end
