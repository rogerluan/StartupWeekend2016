//
//  APIManager.h
//  WaffleTest
//
//  Created by Roger Luan on 5/2/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Order.h"

/**
 *  Completion block called when fetching the orders list.
 *
 *  @param error       NSError containing any error that may occur.
 *  @param list        NSArray containing the requested order list.
 */
typedef void(^ListFetchCompletionBlock)(NSError * _Nullable error, NSArray * _Nullable list);

/**
 *  Completion block called when fetching the image.
 *
 *  @param error    NSError containing any error that may occur.
 *  @param image    UIImage containing the product image.
 */
typedef void(^ImageCompletionBlock)(NSError * _Nullable error, UIImage * _Nullable image);

/**
 *  Completion block called when fetching the order items.
 *
 *  @param error    NSError containing any error that may occur.
 *  @param items    NSArray containing the order items.
 */
typedef void(^OrderItemsCompletionBlock)(NSError * _Nullable error, NSArray * _Nullable items);

@interface APIManager : NSObject

/**
 *  Fetches a list of orders, highest reward first.
 *
 *  @param completion The completion block to call when the request completes.
 */
- (void)fetchOrderListWithCompletion:(nonnull ListFetchCompletionBlock)completion;

/**
 *  Fetches a list of products.
 *
 *  @param completion The completion block to call when the request completes.
 */
- (void)fetchProductsListWithCompletion:(nonnull ListFetchCompletionBlock)completion;

/**
 *  Fetches the image from the given URL.
 *
 *  @param url        URL of the image that is going to be fetched.
 *  @param completion The completion block to call when the request completes.
 */
- (void)fetchImageFromURL:(nonnull NSURL *)url withCompletion:(nonnull ImageCompletionBlock)completion;

/**
 *  Fetches a list with the order items.
 *
 *  @param order      The order that needs its items fetched.
 *  @param completion The completion block to call when the request completes.
 */
- (void)fetchItemsFromOrder:(nonnull Order*)order withCompletion:(nonnull OrderItemsCompletionBlock)completion;


@end
