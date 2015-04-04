//
//  MainViewController.swift
//  QPayiPhone
//
//  Created by Gavin Chu on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    @IBOutlet var userName: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    var isLoggedIn = false;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar;
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default);
        bar.shadowImage = UIImage();
        bar.backgroundColor = UIColor.clearColor();
        
        self.button.layer.borderColor = UIColor.darkGrayColor().CGColor;
        self.button.layer.borderWidth = 1.0;
        self.button.layer.cornerRadius = 4.0;
        
        if (Venmo.sharedInstance().isSessionValid()) {
            self.setUIforLoggedIn();
        } else {
            self.setUIforLoggedOut();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        if (self.isLoggedIn) {
            performSegueWithIdentifier("segueToScanner", sender: nil);
        } else {
            Venmo.sharedInstance().requestPermissions(["make_payments", "access_profile"], withCompletionHandler: { (var success, var error) -> Void in
                if (success) {
                    self.setUIforLoggedIn();
                } else {
                    var alert = UIAlertController(title: "Authorization failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                    println(error);
                }
            });
        }
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        self.setUIforLoggedOut();
    }
    
    func setUIforLoggedIn() {
        self.isLoggedIn = true;
        self.button.setTitle("Scan QR Code", forState: UIControlState.Normal);
        var username = Venmo.sharedInstance().session.user.displayName;
        self.userName.text = "Logged in as " + username;
        self.userName.hidden = false;
        self.logoutButton.hidden = false;
    }
    
    func setUIforLoggedOut() {
        self.isLoggedIn = false;
        self.button.setTitle("Login with Venmo", forState: UIControlState.Normal);
        self.userName.hidden = true;
        self.logoutButton.hidden = true;
    }
    
}