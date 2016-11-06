//
//  ReviewViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@property (strong, nonatomic) IBOutlet UIButton *reviewButton1;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton2;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton3;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton4;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton5;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)reviewButtonPressed:(UIButton *)sender {
    //Everything here is just a dummy.
    if ([sender isEqual:self.reviewButton1]) {
        
    } else if ([sender isEqual:self.reviewButton2]) {
        
    } else if ([sender isEqual:self.reviewButton3]) {
        
    } else if ([sender isEqual:self.reviewButton4]) {
        
    } else {
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
