//
//  APIManager.m
//  WaffleTest
//
//  Created by Roger Luan on 5/2/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

static NSString * const BaseURLString = @"https://cabenocarrinho.herokuapp.com/";

#pragma mark - Public Methods -

- (void)fetchOrderListWithCompletion:(nonnull ListFetchCompletionBlock)completion {
    NSString *paramString = [NSString stringWithFormat:@"%@orders", BaseURLString];
    NSURL *url = [[NSURL alloc] initWithString:paramString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [self showNetworkActivityIndicator:YES];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[[NSURLRequest alloc] initWithURL:url] completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self showNetworkActivityIndicator:NO];
        if (error) {
            completion(error, nil);
        } else {
            NSArray *orders = [self ordersFromJSON:data error:&error];
            if (!error) {
                completion(nil, orders);
            } else {
                completion(error, nil);
            }
        }
    }];
    [task resume];
}

- (void)fetchProductsListWithCompletion:(nonnull ListFetchCompletionBlock)completion {
    NSString *paramString = [NSString stringWithFormat:@"%@", BaseURLString];
    NSURL *url = [[NSURL alloc] initWithString:paramString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [self showNetworkActivityIndicator:YES];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[[NSURLRequest alloc] initWithURL:url] completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self showNetworkActivityIndicator:NO];
        if (error) {
            completion(error, nil);
        } else {
            NSArray *recipes = [self productsFromJSON:data error:&error];
            if (!error) {
                completion(nil, recipes);
            } else {
                completion(error, nil);
            }
        }
    }];
    [task resume];
}

- (void)fetchImageFromURL:(nonnull NSURL *)url withCompletion:(nonnull ImageCompletionBlock)completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self showNetworkActivityIndicator:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [self showNetworkActivityIndicator:NO];
        if (!error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completion(nil, image);
        } else {
            completion(error, nil);
        }
    }];
}

- (void)fetchItemsFromOrder:(nonnull Order*)order withCompletion:(nonnull OrderItemsCompletionBlock)completion {
    NSString *paramString = [NSString stringWithFormat:@"orders/%@", order.identifier];
    NSURL *url = [[NSURL alloc] initWithString:paramString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [self showNetworkActivityIndicator:YES];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[[NSURLRequest alloc] initWithURL:url] completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self showNetworkActivityIndicator:NO];
        if (error) {
            completion(error, nil);
        } else {
            NSError *error = nil;
            NSDictionary *parsedObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                completion(error, nil);
            }
            NSArray *items = [[parsedObjects objectForKey:@"order"] objectForKey:@"items"];
            if (!error) {
                completion(nil, items);
            } else {
                completion(error, nil);
            }
        }
    }];
    [task resume];
}

#pragma mark - Private Methods -

- (NSArray *)ordersFromJSON:(NSData *)data error:(NSError **)error {
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    NSLog(@"parsed object: %@", parsedObject);
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *orders = [NSMutableArray new];
    
    for (NSDictionary *orderDictionary in parsedObject) {
        Order *order = [[Order alloc] initWithDictionary:orderDictionary];
        [orders addObject:order];
    }
    
    return orders;
}

- (NSArray *)productsFromJSON:(NSData *)data error:(NSError **)error {
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *orders = [NSMutableArray new];
    NSArray *results = [parsedObject valueForKey:@"products"];
    
    for (NSDictionary *recipeDictionary in results) {
        Order *order = [[Order alloc] initWithDictionary:recipeDictionary];
        [orders addObject:order];
    }
    return orders;
}

- (void)showNetworkActivityIndicator:(BOOL)show {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:show];
}

@end
