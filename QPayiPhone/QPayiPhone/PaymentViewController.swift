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
    
    override func viewDidLoad() {
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
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    var itemId = metadataObject.stringValue;
                    
                    var completionHandler:(PFObject!, NSError!) -> Void = {
                        (itemObject:PFObject!, error:NSError!) -> Void in
                        if error == nil {
                            print(itemObject);
                        }
                        else {
                            print("Error: " + error.localizedDescription);
                        }
                    }
                    
                    let PaymentObject = PaymentModel();
                    PaymentObject.retrieveDataFromItemId(itemId, completionHandler: completionHandler);
                }
            }
        }
    }
}
