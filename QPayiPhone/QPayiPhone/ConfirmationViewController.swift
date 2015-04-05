//
//  ConfirmationViewController.swift
//  QPayiPhone
//
//  Created by Collin Yen on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import Foundation

class ConfirmationViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var itemId:String = "";
    var itemTitle:String = "";
    var itemDescription:String = "";
    var itemAmount:UInt = 0;
    var itemUserName:String = "";
    
    override func viewDidLoad() {
        print("Title: \(itemTitle)\n");
        print("Amount: \(itemAmount)\n");
        print("Description: \(itemDescription)\n");
        print("Username: \(itemUserName)\n");
        
        self.titleLabel.text = self.itemTitle;
        self.usernameLabel.text = self.itemUserName;
        self.amountLabel.text = NSString(format: "$%.2f", Float(self.itemAmount)/100.0);
        self.descriptionLabel.text = self.itemDescription;
        
        self.confirmButton.layer.borderColor = UIColor(red: 58, green: 173, blue: 255, alpha: 1).CGColor;
        self.confirmButton.layer.borderWidth = 1.0;
        self.confirmButton.layer.cornerRadius = 4.0;
        
        Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API;
    }
    
    @IBAction func pay(sender: AnyObject) {
        var amount = self.amountLabel.text!;
        var message = "Are you sure you want to pay \(amount) to \(self.itemUserName)?";
        var confirmationAlert = UIAlertController(title: "Confirm Payment", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil));
        
        confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.payWithVenmoAPI();
        }));
        
        presentViewController(confirmationAlert, animated: true, completion: nil);
    }
    
    func payWithVenmoAPI() -> Void {
        Venmo.sharedInstance().sendPaymentTo(self.itemUserName, amount: self.itemAmount, note: self.itemTitle + " - " + self.itemDescription, audience: VENTransactionAudience.Public) { (transaction, success, error) -> Void in
            if (success) {
                println("payment success");
                self.recordPayment();
            } else {
                println("Error: " + error.localizedDescription);
            }
        }
    }
    
    func recordPayment() -> Void {
        var completionHandler:(Bool!, NSError!) -> Void = {
            (success:Bool!, error:NSError!) -> Void in
            if success == true {
                self.navigationController?.popToRootViewControllerAnimated(true);
            }
            else {
                print("There was an error saving your payment");
            }
        }

        var username = Venmo.sharedInstance().session.user.username;
        var name = Venmo.sharedInstance().session.user.displayName;
        
        let PaymentObject = PaymentModel();
        PaymentObject.recordPaymentInParse(self.itemId, username: username, name: name, note: "This is a note", completionHandler: completionHandler);
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
}