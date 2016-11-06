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

@property (strong, nonatomic) IBOutlet UITextField *orderIdentifierLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <Item *> *items;
@property (strong, nonatomic) NSMutableArray <Item *> *selectedItems;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) APIManager *APIManager;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
    
    self.items = [NSArray array];
    self.selectedItems = [NSMutableArray array];
    self.APIManager = [APIManager new];
    [self.refreshControl beginRefreshing];
    [self.APIManager fetchProductsListWithCompletion:^(NSError * _Nullable error, NSArray * _Nullable list) {
        if (!error) {
            NSMutableArray *tempItems = [NSMutableArray array];
            for (Product *product in list) {
                Item *item = [[Item alloc] initWithProduct:product];
                [tempItems addObject:item];
            }
            self.items = [tempItems copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Handle error: %@",error.description);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableView Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ProductCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Item *item = [self.items objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.item = item;
    if (!cell.productImageView.image) {
        cell.productImageView.image = [UIImage imageNamed:@"logo"];
    }
    
    if (item.product.image) {
        cell.productImageView.image = item.product.image;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self.APIManager fetchImageFromURL:item.product.url withCompletion:^(NSError * _Nullable error, UIImage * _Nullable image) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (!error && image) {
                        item.product.image = image;
                        cell.productImageView.image = item.product.image;
                        cell.item.product.image = image;
                    } else {
                        NSLog(@"Handle error here loading the image.");
                    }
                });
            }];
        });
    }
}

- (void)refreshTable {
    [self.refreshControl beginRefreshing];
    [self.APIManager fetchProductsListWithCompletion:^(NSError * _Nullable error, NSArray * _Nullable list) {
        if (!error) {
            self.items = list;
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
        for (Item *item in self.selectedItems) {
            if ([item.product.uuid isEqual:cell.item.product.uuid]) {
                [self.selectedItems removeObject:item];
                return;
            }
        }
    }
    
    for (Item *item in self.selectedItems) {
        if ([item.product.uuid isEqual:cell.item.product.uuid]) {
            item.quantity = stepper.value;
            return;
        }
    }
    
    cell.item.quantity = stepper.value;
    [self.selectedItems addObject:cell.item];
    [self updateTotalValue];
}

- (void)updateTotalValue {
    double total = 0;
    for (Item *item in self.selectedItems) {
        total += (item.product.averagePrice.floatValue * item.quantity);
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"Total Pedido: %.2ld", (long)total];
}

#pragma mark - IBAction -

- (IBAction)nextButtonPressed:(UIButton *)sender {
    if (!self.orderIdentifierLabel.hasText) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Seu Nome",nil) message:NSLocalizedString(@"Por favor dê um nome à sua lista. Pode ser o seu próprio nome, para te identificarem com facilidade!",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.items.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Nenhum Item Selecionado",nil) message:NSLocalizedString(@"Você deve selecionar pelo menos 1 item para criar seu pedido.",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self performSegueWithIdentifier:@"OrderAddressSegueIdentifier" sender:self];
}

- (IBAction)dismissOrder:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OrderAddressSegueIdentifier"]) {
        Order *order = [Order new];
        order.items = self.selectedItems;
        order.identifier = self.orderIdentifierLabel.text;
        
        OrderDetailsViewController *vc = (OrderDetailsViewController *)segue.destinationViewController;
        vc.order = order;
    }
}

@end
