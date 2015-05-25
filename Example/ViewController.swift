//
//  ViewController.swift
//  NiceActionSheet
//
//  Created by David Collado Sela on 22/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var selectedIndex = 0
    var vc:NiceActionSheet?
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let button1 = NiceActionSheetButton(title: "Button 1")
        let button2 = NiceActionSheetButton(title: "Button 2", titleColor: UIColor.whiteColor())
        let button3 = NiceActionSheetButton(title: "Button3")
        let button4 = NiceActionSheetButton(title: "Button 4")
        
        vc = NiceActionSheet.show(self, backgroundColor: UIColor.whiteColor(), backgroundAlpha: 0.6, sheetBackgroundColor: UIColor.grayColor(), title: "Title here", titleFont: UIFont.boldSystemFontOfSize(15), titleColor: UIColor.whiteColor(), buttons: [button1,button2,button3,button4], buttonSelectedColor: UIColor.blueColor(), buttonsFont: UIFont.boldSystemFontOfSize(15), buttonSelectedIndex: self.selectedIndex) { (index) -> Void in
            self.selectedIndex = index
            self.indexLabel.text = String(index)
        }
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

