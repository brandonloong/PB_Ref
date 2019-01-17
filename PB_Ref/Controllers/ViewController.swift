//
//  ViewController.swift
//  PBRef
//
//  Created by Brandon Loong on 10/4/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Unwind segue to main menu
	@IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
		print("Yes, this func matters")
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

