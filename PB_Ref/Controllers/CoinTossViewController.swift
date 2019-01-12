//
//  CoinTossViewController.swift
//  PBRef
//
//  Created by Brandon Loong on 10/6/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

import UIKit

class CoinTossViewController: UIViewController {
	
	// Labels, fields, images
	@IBOutlet weak var chosenTeamLabel: UILabel!
	@IBOutlet weak var step2Label: UILabel!
	@IBOutlet weak var randNumLabel: UILabel!
	
	// Variables
	let dur_0 = 0.08
	var r1 = 0, r2 = 0, iter = 1, nIter = 10    // nIter needs to be even
	var timer1 = Timer(), timer2 = Timer()
	
	/*------------------------------------------------------------------------------------------------*/
	// Functions
	
	// Team timer1 delay
	@objc func animateRandTeam() {
		if iter > nIter {		// keep final iter even so that label will return to default colors
			// Animation finished
			timer1.invalidate()
			step2Label.text = "Step 2: Team \(r1) picks a number (1 or 2)"
		}
		else {
			r1 = Int(arc4random_uniform(2)) + 1		// choose random number between 1-2
			chosenTeamLabel.text = "Team \(r1)"
			
			if (iter%2) == 0 {	// alternate background/text colors every iter
				chosenTeamLabel.backgroundColor = UIColor.white
				chosenTeamLabel.textColor = UIColor.black
			} else {
				chosenTeamLabel.backgroundColor = UIColor.black
				chosenTeamLabel.textColor = UIColor.white
			}
		}
		iter += 1
	}
	// Number timer1 delay
	@objc func animateRandNum() {
		if iter > nIter {		// keep final iter even so that label will return to default colors
			// Animation finished
			timer2.invalidate()
			randNumLabel.backgroundColor = UIColor.white
			randNumLabel.text = "\(r2)"
		}
		else {
			r2 = Int(arc4random_uniform(2)) + 1		// choose random number between 1-2
			randNumLabel.text = "\(r2)"
			
			if (iter%2) == 0 {	// alternate background/text colors every iter
				randNumLabel.backgroundColor = UIColor.white
				randNumLabel.textColor = UIColor.black
			} else {
				randNumLabel.backgroundColor = UIColor.black
				randNumLabel.textColor = UIColor.white
			}
		}
		iter += 1
	}
	
	/*------------------------------------------------------------------------------------------------*/
	// Buttons
	
	@IBAction func pickTeamButton(_ sender: UIButton) {
		// Simple function (non-animated)
		//r1 = Int(arc4random_uniform(2)) + 1
		//chosenTeamLabel.text = "Team \(r1)"
		//step2Label.text = "Step 2: Team \(r1) picks a number (1 or 2)"
		
		// Prep label for animation
		chosenTeamLabel.backgroundColor = UIColor.black
		chosenTeamLabel.textColor = UIColor.white
		// Start animation
		timer1 = Timer.scheduledTimer(timeInterval: dur_0, target: self, selector: #selector(CoinTossViewController.animateRandTeam), userInfo: nil, repeats: true)
		// Animation finished
		iter = 0
	}
	@IBAction func randNumButton(_ sender: UIButton) {
		// Prep label for animation
		randNumLabel.backgroundColor = UIColor.black
		randNumLabel.textColor = UIColor.white
		// Start animation
		timer2 = Timer.scheduledTimer(timeInterval: dur_0, target: self, selector: #selector(CoinTossViewController.animateRandNum), userInfo: nil, repeats: true)
		// Animation finished
		iter = 0
	}
	@IBAction func clearButton(_ sender: UIButton) {
		// Stop animateRandNum() & reset labels
		timer1.invalidate(); timer2.invalidate()
		chosenTeamLabel.backgroundColor = UIColor.white
		chosenTeamLabel.textColor = UIColor.black
		randNumLabel.backgroundColor = UIColor.white
		randNumLabel.textColor = UIColor.black
		
		r1 = 0; r2 = 0
		chosenTeamLabel.text = "?"
		step2Label.text = "Step 2: Team ? picks a number (1 or 2)"
		randNumLabel.text = "?"
	}
	
	/*------------------------------------------------------------------------------------------------*/
	// Standard stuff
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
