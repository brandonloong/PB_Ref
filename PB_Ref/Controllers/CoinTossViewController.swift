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
	@IBOutlet weak var step1ResultLabel: UILabel!
	@IBOutlet weak var step2Label: UILabel!
	@IBOutlet weak var randNumButtonOutlet: UIButton!
	@IBOutlet weak var randNumLabel1: UILabel!
	@IBOutlet weak var randNumLabel2: UILabel!
	@IBOutlet weak var randNumLabel3: UILabel!
	
	// Variables
	let dur_0 = 0.08
	var r1 = 0, r2 = 0, iter = 1, nIter = 10    // nIter needs to be even
	var timer1 = Timer(), timer2 = Timer()
	
	/*------------------------------------------------------------------------------------------------*/
	// Functions
	
	// Team timer1 delay
	@objc func animateRandTeam() {
		if iter > nIter {		// keep final iter even so that label will return to default colors
			// Timer finish
			timer1.invalidate()
			step1ResultLabel.text = "Team \(r1) picks a number (1 or 2)"
			toggleViewOn(true)
			iter = 0
		} else {
			// Timer continue
			r1 = Int(arc4random_uniform(2)) + 1
			chosenTeamLabel.text = "Team \(r1)"
			alternateColors(label: chosenTeamLabel, count: iter)
		}
		iter += 1
	}
	// Number timer2 delay
	@objc func animateRandNum() {
		if iter > nIter {		// keep iter=even so the label will return to default colors
			// Timer finish
			timer2.invalidate()
			randNumLabel2.text = "\(r2)"
			defaultColors()
			iter = 0
		} else {
			// Timer continue
			r2 = Int(arc4random_uniform(2)) + 1
			randNumLabel2.text = "\(r2)"
			alternateColors(label: randNumLabel2, count: iter)
		}
		iter += 1
	}
	// Alternate colors while timer runs
	func alternateColors(label: UILabel, count: Int) {
		if (count%2) == 0 {
			label.backgroundColor = UIColor.white
			label.textColor = UIColor.black
		} else {
			label.backgroundColor = UIColor.black
			label.textColor = UIColor.white
		}
	}
	// Toggle display elements on or off
	func toggleViewOn(_ show: Bool) {
		let status = !show
		
		// Show/hide views
		step1ResultLabel.isHidden = status
		step2Label.isHidden = status
		randNumButtonOutlet.isHidden = status
		randNumLabel1.isHidden = status
		randNumLabel2.isHidden = status
		randNumLabel3.isHidden = status
		
		// Reset colors
		defaultColors()
		// Reset text
		if status {
			chosenTeamLabel.text = "?"
			randNumLabel2.text = "?"
		}
	}
	// Default colors
	func defaultColors() {
		chosenTeamLabel.backgroundColor = UIColor.white
		chosenTeamLabel.textColor = UIColor.black
		randNumLabel2.backgroundColor = UIColor.white
		randNumLabel2.textColor = UIColor.black
	}
	
	/*-IBActions----------------------------------------------------------------------------*/
	// Pick a random team
	@IBAction func pickTeamButton(_ sender: UIButton) {
		// Start timer
		timer1 = Timer.scheduledTimer(timeInterval: dur_0, target: self, selector: #selector(CoinTossViewController.animateRandTeam), userInfo: nil, repeats: true)
	}
	// Generate a random number
	@IBAction func randNumButton(_ sender: UIButton) {
		// Start timer
		timer2 = Timer.scheduledTimer(timeInterval: dur_0, target: self, selector: #selector(CoinTossViewController.animateRandNum), userInfo: nil, repeats: true)
	}
	// Reset the screen
	@IBAction func clearButton(_ sender: UIButton) {
		// Stop any lingering timers
		timer1.invalidate(); timer2.invalidate()
		
		// Reset random num just to be sure of no memory effects
		r1 = 0; r2 = 0
		
		// Toggle display
		toggleViewOn(false)
	}
	
	/*-------------------------------------------------------------------------------------*/
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
