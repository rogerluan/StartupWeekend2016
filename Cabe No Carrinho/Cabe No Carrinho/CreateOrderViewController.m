//
//  CreateOrderViewController.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "ProductCell.h"
#import "APIManager.h"
#import "OrderDetailsViewController.h"

static NSString * const ProductCellIdentifier = @"ProductCellIdentifier";

@interface CreateOrderViewController () <UITableViewDelegate, UITableViewDataSource, ProductCellDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <Product *> *products;
@property (strong, nonatomic) NSMutableArray <Item *> *items;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) APIManager *APIManager;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self refreshTable];
    
    self.items = [NSMutableArray array];
    self.APIManager = [APIManager new];
    [self.APIManager fetchProductsListWithCompletion:^(NSError * _Nullable error, NSArray * _Nullable productList) {
        if (!error) {
            self.products = productList;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshTable];
            });
        } else {
            NSLog(@"Did error: %@", error);
        }
    }];
}

#pragma mark - UITableView Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ProductCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Product *product = [self.products objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.item.product = product;
    if (!cell.productImageView.image) {
        cell.productImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self.APIManager fetchImageFromURL:product.url withCompletion:^(NSError * _Nullable error, UIImage * _Nullable image) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (!error && image) {
                    product.image = image;
                    cell.productImageView.image = product.image;
                } else {
                    NSLog(@"Handle error here loading the image.");
                }
            });
        }];
    });
}

- (void)refreshTable {
    [self.refreshControl beginRefreshing];
    [self.APIManager fetchProductsListWithCompletion:^(NSError * _Nullable error, NSArray * _Nullable list) {
        if (!error) {
            self.products = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Handle error: %@",error.description);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITextField Delegate - 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self.view endEditing:YES];
}

#pragma mark - Product Cell Delegate - 

- (void)productCell:(ProductCell *)cell didStep:(UIStepper *)stepper {
    if (stepper.value == 0) {
        for (Item *item in self.items) {
            if ([item.product isEqual:cell.item.product]) {
                [self.items removeObject:item];
                return;
            }
        }
    }
    
    for (Item *item in self.items) {
        if ([item.product isEqual:cell.item.product]) {
            item.quantity = stepper.value;
            return;
        }
    }
    
    Item *item = [Item new];
    item.product = cell.item.product;
    item.quantity = stepper.value;
    [self.items addObject:item];
}

#pragma mark - IBAction -

- (IBAction)nextButtonPressed:(UIButton *)sender {
    if (self.items.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Nenhum Item Selecionado",nil) message:NSLocalizedString(@"Você deve selecionar pelo menos 1 item para criar seu pedido.",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self performSegueWithIdentifier:@"OrderAddressSegueIdentifier" sender:self];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OrderAddressSegueIdentifier"]) {
        Order *order = [Order new];
        order.items = self.items;
        
        OrderDetailsViewController *vc = (OrderDetailsViewController *)segue.destinationViewController;
        vc.order = order;
    }
}

@end
