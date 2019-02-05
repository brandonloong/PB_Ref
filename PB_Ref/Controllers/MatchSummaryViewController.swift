//
//  MatchSummaryViewController.swift
//  PBRef
//
//  Created by Brandon Loong on 10/4/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

import UIKit

class MatchSummaryViewController: UIViewController {
	
	// Labels
	@IBOutlet weak var t1WinLabel: UILabel!
	@IBOutlet weak var t2WinLabel: UILabel!
	@IBOutlet weak var p1Label: UILabel!
	@IBOutlet weak var p2Label: UILabel!
	@IBOutlet weak var p3Label: UILabel!
	@IBOutlet weak var p4Label: UILabel!
	@IBOutlet weak var g1TimeLabel: UILabel!
	@IBOutlet weak var g1RallyLabel: UILabel!
	@IBOutlet weak var g1T1Runner: UILabel!
	@IBOutlet weak var g1T2Runner: UILabel!
	@IBOutlet weak var g1T1TOLabel: UILabel!
	@IBOutlet weak var g1T2TOLabel: UILabel!
//	@IBOutlet weak var g2TimeLabel: UILabel!
//	@IBOutlet weak var g2T1Runner: UILabel!
//	@IBOutlet weak var g2T2Runner: UILabel!
//	@IBOutlet weak var g3TimeLabel: UILabel!
//	@IBOutlet weak var g3T1Runner: UILabel!
//	@IBOutlet weak var g3T2Runner: UILabel!
	
	// Variables
	var match = DoublesMatch()		// transfer current match
	var matchOver = false
	
	// Arrays
	var setRecord = ["","","","","",""], ipTextArray = ["","","",""]
	var winLabels = [UILabel](), pLabels = [UILabel]()
	
	
	/*------------------------------------------------------------------------------------------------*/
	// Functions
	
	
	
	
	/*------------------------------------------------------------------------------------------------*/
	// Buttons
	
	
	
	/*------------------------------------------------------------------------------------------------*/
	// Standard stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		// Arrays
		winLabels = [t1WinLabel,t2WinLabel]
		pLabels = [p1Label,p2Label,p3Label,p4Label]
		
		// Setup view
		if let winner = match.matchWinner {
			winLabels[winner-1].text = "Won"
			winLabels[(winner)%2].text = "Lost"
		}
		for i in 0...3 {pLabels[i].text = match.playerNames[i]}	// update pLabels
		
		
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
