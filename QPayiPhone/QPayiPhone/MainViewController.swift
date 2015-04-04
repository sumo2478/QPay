//
//  MainViewController.swift
//  QPayiPhone
//
//  Created by Gavin Chu on 4/4/15.
//  Copyright (c) 2015 Gavin Chu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}