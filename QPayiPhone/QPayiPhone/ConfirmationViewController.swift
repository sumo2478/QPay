//
//  ConfirmationViewController.swift
//  QPayiPhone
//
//  Created by Collin Yen on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import Foundation

class ConfirmationViewController: UIViewController {
    var itemTitle:String = "";
    var itemDescription:String = "";
    var itemAmount:UInt = 0;
    var itemUserName:String = "";
    
    override func viewDidLoad() {
        print("Title: \(itemTitle)\n");
        print("Amount: \(itemAmount)\n");
        print("Description: \(itemDescription)\n");
        print("Username: \(itemUserName)\n");
    }
    
    
}