//
//  ViewController.m
//  QPayiPhone
//
//  Created by Gavin Chu on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

#import "ViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <Parse/Parse.h>

@interface ViewController()

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isReading = NO;
    self.captureSession = nil;
    
    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanButtonPressed:(id)sender {
    self.isReading = !self.isReading;
    if (self.isReading) {
        if ([self startReading]) {
            self.preview.hidden = NO;
            [self.scanButton setTitle:@"Stop" forState:UIControlStateNormal];
            //[_lblStatus setText:@"Scanning for QR Code..."];
        }
    } else {
        [self stopReading];
        self.preview.hidden = YES;
        [self.scanButton setTitle:@"Scan QR Code" forState:UIControlStateNormal];
    }
}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize captureSession if input is valid
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    
    // Specify an output
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    // use queue because app should not execute any other tasks
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize camera preview
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.preview.layer.bounds];
    [self.preview.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            //[_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            NSLog(@"QR Code: %@", [metadataObj stringValue]);
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            self.preview.hidden = YES;
            [self.scanButton setTitle:@"Scan QR Code" forState:UIControlStateNormal];
            self.isReading = NO;
        }
    }
}

- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
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
