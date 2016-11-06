//
//  OrderDetailsViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderConfirmedViewController.h"
#import "APIManager.h"

@interface OrderDetailsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UILabel *rewardLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) APIManager *APIManager;

@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    self.datePicker.minimumDate = [NSDate date];
    self.APIManager = [APIManager new];
}

#pragma mark - IBAction -

- (IBAction)didStep:(UIStepper *)sender {
    self.rewardLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
}

- (IBAction)didRequestOrder:(UIButton *)sender {
    if (!self.addressTextField.hasText) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sem Endereço",nil) message:NSLocalizedString(@"Por favor informe o endereço que os produtos devem ser entregues.",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.order.address = [self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.order.reward = self.rewardLabel.text.integerValue;
    
    [SVProgressHUD show];
    [self.APIManager createOrder:self.order completion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"RequestOrderSegueIdentifier" sender:self];
            });
        } else {
            NSLog(@"Failed with error: %@ WHEN creating order!", error);
        }
    }];
}

- (IBAction)dismissOrder:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self.view endEditing:YES];
}

#pragma mark - Navigation - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RequestOrderSegueIdentifier"]) {
        OrderConfirmedViewController *vc = (OrderConfirmedViewController *)segue.destinationViewController;
        vc.order = self.order;
    }
}

@end
