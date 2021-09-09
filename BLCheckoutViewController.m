//
//  BLCheckoutViewController.m
//  ShoppingCart
//
//  Created by Bennett Lee on 7/14/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLCheckoutViewController.h"
#import "BLCart.h"

@interface BLCheckoutViewController () <UIWebViewDelegate, DpayCheckoutProtocol>

@end

@implementation BLCheckoutViewController

#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    DpaySDK *dpaySDK = [DpaySDK getInstance];
    DCheckoutOptions *options = [[DCheckoutOptions alloc] init];
    NSDictionary *orderResponse = [self getAccessToken];
    NSString *access_token = [orderResponse objectForKey:@"access_token"];
    NSString *order_id = [orderResponse objectForKey:@"order_id"];
    [self buildCheckoutOptions:options access_token:access_token order_id:order_id];
    [dpaySDK checkoutWithOptions:options listener: self];
}

- (void)buildCheckoutOptions:(DCheckoutOptions *)options access_token:(NSString *) access_token
                    order_id:(NSString *) order_id {
    [options setLocale:@"en"];
    [options setEnvironment:@"production"];
    [options setCustomerId:@"cust_001"];
    [options setSiteName:@"Movie Ticket"];
    [options setAmount:@"10000"];
    [options setCurrency:@"IDR"];
    [options setCustomerEmail:@"joe@doe.com"];
    [options setCustomerGivenName:@"Joe Doe"];
    [options setAccessToken:access_token];
    [options setOrderId:order_id];
}

-(NSDictionary *)getAccessToken {

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    spinner.alpha = 1.0;
    spinner.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    __block NSMutableDictionary *resultsDictionary;

    NSDictionary *customerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"cust_001", @"customer_rf_id",@"jow@doe.com",@"email", @"Doe", @"given_name", nil];
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"15000", @"amount",@"IDR",@"currency", @"ord_001", @"order_ref_id", customerDictionary, @"customer", nil];
    
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {//validate it
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        NSURL* url = [NSURL URLWithString:@"https://pzfvd7ixh2.execute-api.us-east-1.amazonaws.com/orders"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];//use POST
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:jsonData];//set data
        NSURLResponse *response = [[NSURLResponse alloc] init];
        __block NSError *error1 = [[NSError alloc] init];

        //use async way to connect network
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error:&error1];
        if ([data length]>0 && error == nil) {
            resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
            NSLog(@"resultsDictionary is %@",resultsDictionary);
        } else if ([data length]==0 && error ==nil) {
            NSLog(@" download data is null");
        } else if( error!=nil) {
            NSLog(@" error is %@",error);
        }
    }
    return resultsDictionary;
    [spinner stopAnimating];
}


- (void)onCloseWithTransactionResponse:(NSString * _Nonnull)transactionResponse {
    printf("%s", transactionResponse);
}

- (void)onErrorWithTransactionResponse:(NSString * _Nonnull)transactionResponse {
    printf("%s", transactionResponse);
}

- (void)onSuccessWithTransactionResponse:(NSString * _Nonnull)transactionResponse {
    printf("%s", transactionResponse);
}

@end



