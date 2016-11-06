//
//  OrdersViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderCell.h"
#import "APIManager.h"
#import "ChecklistViewController.h"

static NSString * const OrderCellIdentifier = @"OrderCellIdentifier";

@interface OrdersViewController () <UITableViewDelegate, UITableViewDataSource, OrderCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) APIManager *APIManager;
@property (strong, nonatomic) NSArray <Order *> *orders;

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.orders = [NSArray array];
    [self refreshTable];
}

#pragma mark - UITableView Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    Order *order = [self.orders objectAtIndex:indexPath.row];
    cell.order = order;
    return cell;
}

- (void)refreshTable {
    [self.refreshControl beginRefreshing];
    if (!self.APIManager) {
        self.APIManager = [APIManager new];
    }
    [self.APIManager fetchOrderListWithCompletion:^(NSError * _Nullable error, NSArray * _Nullable list) {
        if (!error) {
            self.orders = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Handle error: %@",error.description);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Order Cell Delegate - 

- (void)orderCell:(OrderCell *)cell didChooseOrder:(Order *)order {
    [SVProgressHUD show];
    //to-do: APIManager performs order selection
    [self performSegueWithIdentifier:@"ChecklistSegueIdentifier" sender:order];
    [SVProgressHUD dismiss];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChecklistSegueIdentifier"]) {
        ChecklistViewController *vc = (ChecklistViewController *)segue.destinationViewController;
        vc.order = (Order *)sender;
    }
}

- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
