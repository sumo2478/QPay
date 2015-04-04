//
//  ViewController.m
//  QPayiPhone
//
//  Created by Gavin Chu on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

#import "ViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payButtonPressed:(id)sender {
    void(^handler)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
        if (error) {
            UIAlertView *failAlertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                                message:error.localizedRecoverySuggestion
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [failAlertView show];
        }
        else {
            UIAlertView *successAlertview = [[UIAlertView alloc] initWithTitle:@"Transaction succeeded!" message:[NSString stringWithFormat:@"You have paid %@ $%d", @"Collin Yen", 1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [successAlertview show];
        }
    };

    [[Venmo sharedInstance] sendPaymentTo:@"venmo@venmo.com"
                                   amount:1.0
                                     note:@"test"
                        completionHandler:handler];
}

@end
