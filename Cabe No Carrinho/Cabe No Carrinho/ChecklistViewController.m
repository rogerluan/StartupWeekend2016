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
@property (strong, nonatomic) NSArray *items;

@end

@implementation ChecklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.APIManager = [APIManager new];
    [SVProgressHUD show];
    [self.APIManager fetchItemsFromOrder:self.order withCompletion:^(NSError * _Nullable error, NSArray * _Nullable items) {
        if (!error) {
            self.items = items;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Did error: %@", error);
        }
    }];
}

#pragma mark - UITableView Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChecklistCellIdentifier forIndexPath:indexPath];
    Item *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.product.name;
    
    if ([indexPath isEqual:tableView.indexPathForSelectedRow]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (!cell.imageView.image) {
        cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
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
    
    return cell;
}

- (IBAction)doneTapped:(UIButton *)sender {
    //to-do: validate if all the items have been checked out.
    [self performSegueWithIdentifier:@"OrderBoughtSegueIdentifier" sender:self];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OrderBoughtSegueIdentifier"]) {
        OrderBoughtViewController *vc = (OrderBoughtViewController *)segue.destinationViewController;
        vc.order = (Order *)sender;
    }
}

@end
