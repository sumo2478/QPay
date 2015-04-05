//
//  PaymentViewController.swift
//  QPayiPhone
//
//  Created by Collin Yen on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import Foundation
import AVFoundation

class PaymentViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var receivedData:Bool = false;
    var itemObject:PFObject?;
    var itemId: String?;
    
    @IBOutlet var QRBoxView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        self.receivedData = false;
        self.itemObject = nil;
        self.itemId = nil;
        self.captureQRCode();
    }
    
    func captureQRCode() {
        let session = AVCaptureSession()
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: nil) as AVCaptureDeviceInput
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let bounds = self.view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.bounds = bounds
        previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        self.view.layer.addSublayer(previewLayer)
        
        let QRBoxView = UIImageView(image: UIImage(named: "QRBox"));
        QRBoxView.frame = CGRect(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2, width: 300, height: 300);
        QRBoxView.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2);
        self.view.addSubview(QRBoxView);
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    if  !receivedData {
                        receivedData = true;
                        self.itemId = metadataObject.stringValue;
                        
                        var completionHandler:(PFObject!, NSError!) -> Void = {
                            (itemObject:PFObject!, error:NSError!) -> Void in
                            if error == nil {
                                self.itemObject = itemObject;
                                self.performSegueWithIdentifier("segueToPaymentDetail", sender: nil);
                            } else {
                                var alert = UIAlertController(title: "Scanning failed", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert);
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                                    self.navigationController?.popToRootViewControllerAnimated(true);
                                    return;
                                }));
                                self.presentViewController(alert, animated: true, completion: nil);
                                
                                print("Error: " + error.localizedDescription);
                            }
                        }
                        
                        let PaymentObject = PaymentModel();
                        PaymentObject.retrieveDataFromItemId(self.itemId!, completionHandler: completionHandler);
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToPaymentDetail") {
            let destinationViewController = segue.destinationViewController as ConfirmationViewController
            destinationViewController.itemId = self.itemId!
            destinationViewController.itemTitle = self.itemObject!.objectForKey("title") as String;
            destinationViewController.itemAmount = self.itemObject!.objectForKey("amount") as UInt;
            destinationViewController.itemDescription = self.itemObject!.objectForKey("description") as String;
            destinationViewController.itemUserName = self.itemObject!.objectForKey("vusername") as String;
        }
        
    }
}
