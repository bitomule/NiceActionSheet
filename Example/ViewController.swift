//
//  ViewController.swift
//  NiceActionSheet
//
//  Created by David Collado Sela on 22/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showActionSheet(sender: AnyObject) {
        NiceActionSheet.show(self, title: "Lato", titleFont: UIFont.systemFontOfSize(15), titleColor: UIColor.redColor())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

