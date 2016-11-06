//
//  ChecklistViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "ChecklistViewController.h"
#import "APIManager.h"
#import "OrderBoughtViewController.h"

static NSString * const ChecklistCellIdentifier = @"ChecklistCellIdentifier";

@interface ChecklistViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APIManager *APIManager;

@end

@implementation ChecklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.APIManager = [APIManager new];
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.order.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChecklistCellIdentifier forIndexPath:indexPath];
    Item *item = [self.order.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.product.name;
        
    if (!cell.imageView.image) {
        cell.imageView.image = [UIImage imageNamed:@"logo"];
    }
    
    if (item.product.image) {
        cell.imageView.image = item.product.image;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self.APIManager fetchImageFromURL:item.product.url withCompletion:^(NSError * _Nullable error, UIImage * _Nullable image) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (!error && image) {
                        item.product.image = image;
                        cell.imageView.image = item.product.image;
                    } else {
                        NSLog(@"Handle error here loading the image.");
                    }
                });
            }];
        });
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
}

- (IBAction)doneTapped:(UIButton *)sender {
    //to-do: validate if all the items have been checked out.
    [self performSegueWithIdentifier:@"OrderBoughtSegueIdentifier" sender:self.order];
}
- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OrderBoughtSegueIdentifier"]) {
        OrderBoughtViewController *vc = (OrderBoughtViewController *)segue.destinationViewController;
        vc.order = (Order *)sender;
    }
}

@end
