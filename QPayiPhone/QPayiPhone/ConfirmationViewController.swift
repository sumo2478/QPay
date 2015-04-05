//
//  ConfirmationViewController.swift
//  QPayiPhone
//
//  Created by Collin Yen on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import Foundation

class ConfirmationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var usernameLabel: UILabel!
//    @IBOutlet var amountLabel: UILabel!
//    @IBOutlet var descriptionLabel: UILabel!
//    @IBOutlet var confirmButton: UIButton!
//    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!;
    
    
    var itemId:String = "";
    var itemTitle:String = "";
    var itemDescription:String = "";
    var itemAmount:UInt = 0;
    var itemUserName:String = "";
    var formattedAmount:String = "";
    
    override func viewDidLoad() {
        self.formattedAmount = NSString(format: "$%.2f", Float(self.itemAmount)/100.0);
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        
        print("Title: \(itemTitle)\n");
        print("Amount: \(itemAmount)\n");
        print("Description: \(itemDescription)\n");
        print("Username: \(itemUserName)\n");
//        self.titleLabel.text = self.itemTitle;
//        self.usernameLabel.text = self.itemUserName;
//        self.amountLabel.text = NSString(format: "$%.2f", Float(self.itemAmount)/100.0);
//        self.descriptionLabel.text = self.itemDescription;
//        
//        self.confirmButton.layer.borderColor = UIColor(red: 58, green: 173, blue: 255, alpha: 1).CGColor;
//        self.confirmButton.layer.borderWidth = 1.0;
//        self.confirmButton.layer.cornerRadius = 4.0;
        
        Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 115;
        }
        else if (indexPath.row == 2) {
            return 80;
        }
        else {
            return 44;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            var cell:TitleTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TitleTableViewCell") as TitleTableViewCell;
            
            cell.titleLabel.text = self.itemTitle;
            cell.descriptionLabel.text = self.itemDescription;
            
            return cell;
        }
        else if (indexPath.row == 1) {
            var cell:AmountTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AmountTableViewCell") as AmountTableViewCell;
            
            cell.payToLabel.text = "Pay To: \(self.itemUserName)";
            cell.amountLabel.text = "Amount: \(self.formattedAmount)";
            
            return cell;
        }
        else if (indexPath.row == 2) {
            var cell:NotesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("NotesTableViewCell") as NotesTableViewCell;
            
            return cell;
        }
        else if (indexPath.row == 3) {
            var cell:PayTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("PayTableViewCell") as PayTableViewCell;
            
            return cell;
        }
        else {
            return UITableViewCell();
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        if (indexPath.row == 3) {
            var message = "Are you sure you want to pay \(self.formattedAmount) to \(self.itemUserName)?";
            var confirmationAlert = UIAlertController(title: "Confirm Payment", message: message, preferredStyle: UIAlertControllerStyle.Alert);
            
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil));
            
            confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.payWithVenmoAPI();
            }));
            
            presentViewController(confirmationAlert, animated: true, completion: nil);
        }
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
        
        var indexPath:NSIndexPath = NSIndexPath(forRow: 2, inSection: 0);
        var notesCell = self.tableView.cellForRowAtIndexPath(indexPath) as NotesTableViewCell;
        var itemNote = notesCell.notesTextView.text;

        var username = Venmo.sharedInstance().session.user.username;
        var name = Venmo.sharedInstance().session.user.displayName;
        
        let PaymentObject = PaymentModel();
        PaymentObject.recordPaymentInParse(self.itemId, username: username, name: name, note: itemNote, completionHandler: completionHandler);
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
}