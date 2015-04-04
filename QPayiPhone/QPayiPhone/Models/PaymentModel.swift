//
//  PaymentModel.swift
//  QPayiPhone
//
//  Created by Collin Yen on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import Foundation

class PaymentModel {
    func sendPayment(itemId:String, usernameToSendTo:String, amount:UInt, note:String) -> Bool {
        // Send the payment via venmo
        Venmo.sharedInstance().sendPaymentTo(usernameToSendTo, amount:amount, note: note) { (transaction, happen, error) -> Void in
            if error == nil {
                println("Success");
            }
            else {
                println("Failure: " + error.localizedDescription);
            }
        }
        
        return true;
    }
}