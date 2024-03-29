//
//  SetupMatchViewController.swift
//  PBRef
//
//  Created by Brandon Loong on 10/4/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

import UIKit

class SetupMatchViewController: UIViewController, UITextFieldDelegate {
    
    // Fields
	@IBOutlet var p1Field: UITextField!;	@IBOutlet var p2Field: UITextField!
	@IBOutlet var p3Field: UITextField!;	@IBOutlet var p4Field: UITextField!
    // Image views
    @IBOutlet weak var d1Image: UIImageView!;   @IBOutlet weak var d2Image: UIImageView!
    @IBOutlet weak var refImage: UIImageView!
    // Segmented outlets
	@IBOutlet weak var posTypeOutlet: UISegmentedControl!
    @IBOutlet weak var matchTypeOutlet: UISegmentedControl!
    @IBOutlet weak var pointTypeOutlet: UISegmentedControl!
    @IBOutlet weak var gameTypeOutlet: UISegmentedControl!
	@IBOutlet weak var switchTypeOutlet: UISegmentedControl!
	// Buttons
    @IBOutlet weak var swap0ButtonOutlet: UIButton!
    @IBOutlet weak var swap1ButtonOutlet: UIButton!
	
    // Variables
    var activeTag = Int(), activeIndex = Int(), nextIndex = Int(), nextTag = Int()
	var activeField = UITextField()
    // Arrays
    let p0TextArray = ["Player 1","Player 2","Player 3","Player 4"]
    var pTextArray = [String]()
    var pFieldArray = [UITextField](), dImageArray = [UIImageView]()
	// UserDefaults for saving preferences
	let resetArray = [0,0,0,0,0]
	var paramsArray = [0,0,0,0,0]	// [posType, matType, pointType, gameType, switchType]
	let matchDefaults = UserDefaults.standard
	
    /*-Functions-------------------------------------------------------------*/
    // Switch player spots on same side (update array and view)
    func swapSpots(side: Int) {
        if side == 0 {pTextArray.swapAt(0,1)}	// swap left side
		else {pTextArray.swapAt(2,3)}		// swap right side
		updateFields(f: pTextArray)
    }
    // Rotate player spots: add 2 to every player spot mod 4
    func swapSides() {
        pTextArray = [2,3,0,1].map({pTextArray[$0]})
		updateFields(f: pTextArray)
    }
	// Switch ref facing direction and serv dot
	func swapRef(side: Int) {
		let show = (side==0 ? 0 : 1)
		let hide = (side==1 ? 0 : 1)
		dImageArray[show].isHidden = false
		dImageArray[hide].isHidden = true
		refImage.image = UIImage(named: "tourny_ref_icon_vp\(side).png")
	}
	// Update player fields
	func updateFields(f: [String]) {
		savePlayers(f)
		for i in 0...3 {pFieldArray[i].text = f[i]}
	}
	// Check all fields for blanks, and reset with default text
	func resetBlankFields() {
		var holder = String()
		for i in 0...3 {
			holder = pFieldArray[i].text!
			pTextArray[i] = (holder=="" ? "Player \(i+1)" : holder)
			pFieldArray[i].text = pTextArray[i]
		}
	}
	// Display the doubles partner fields and the doubles buttons
	func showDoubles(_ hidden: Bool) {
		p2Field.isHidden = hidden
		p4Field.isHidden = hidden
		swap0ButtonOutlet.isHidden = hidden
		swap1ButtonOutlet.isHidden = hidden
		
		if !hidden {	// update field text to default
			if let players = matchDefaults.array(forKey: "defaultPlayers") as? [String] {
				pTextArray = players
				print("showDoubles_playerDefaults_if")
			} else {
				pTextArray = p0TextArray	// is this necessary? is there ever a nil matchDefaults?
				print("showDoubles_playerDefaults_else")
			}
		}
	}
    // Save player names from text array into
	func savePlayers(_ f: [String]) {
        matchDefaults.set(f, forKey: "defaultPlayers")
    }
	// Save parameters for buttons
	func saveButtons(_ p: [Int]) {
		paramsArray = p
		matchDefaults.set(p, forKey: "defaultParams")
	}
	// Update buttons to specified values
	func updateButtons(params: [Int]) {
		saveButtons(params)
		posTypeOutlet.selectedSegmentIndex = params[0]
		matchTypeOutlet.selectedSegmentIndex = params[1]
		pointTypeOutlet.selectedSegmentIndex = params[2]
		gameTypeOutlet.selectedSegmentIndex = params[3]
		switchTypeOutlet.selectedSegmentIndex = params[4]
	}
	
    /*-IBActions-------------------------------------------------------------*/
    // Unwind to Setup Match VC
    @IBAction func unwindToSetupMatch(segue: UIStoryboardSegue) {}
	// Swap players on the same side
    @IBAction func swapPlayersButton(_ sender: UIButton) {
		swapSpots(side: sender.tag)
    }
	// Swap teams to different sides
	@IBAction func swapSidesButton(_ sender: UIButton) {
		swapSides()
	}
	// Reset to default match
	@IBAction func resetSetupButton(_ sender: UIButton) {
		pTextArray = p0TextArray		// reset player names
		updateFields(f: pTextArray)		// update the fields
		updateButtons(params: resetArray)	// reset button values
		swapRef(side: 0)         		// reset ref and serv dot
		showDoubles(false)				// show doubles buttons & fields
	}
	@IBAction func startMatchButton(_ sender: UIButton) {
	}
	// Update param function for all param buttons
	@IBAction func paramButton(_ sender: UISegmentedControl) {
		let t = sender.tag					// which button was clicked
		let s = sender.selectedSegmentIndex	// which value was clicked
		
		// Save parameters
		paramsArray[t] = s
		matchDefaults.set(paramsArray, forKey: "defaultParams")
		
		// Extra functionality for 2 buttons (use switch to add more buttons)
		if t==0 {			// initial posession button pressed
			swapRef(side: s)
		} else if t==1 {	// match type button pressed
			let hidden = (s==0 ? false : true)
			showDoubles(hidden)
		}
		print("paramButton \(paramsArray)")
	}
	
    /*-Other Functions-------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Arrays
        pTextArray = p0TextArray
        pFieldArray = [p1Field,p2Field,p3Field,p4Field]
        dImageArray = [d1Image,d2Image]
		
		// Update buttons with last selected parameters
		if let paramsArray = matchDefaults.array(forKey: "defaultParams") as? [Int] {
			updateButtons(params: paramsArray)
		}
		if let players = matchDefaults.array(forKey: "defaultPlayers") as? [String] {
			pTextArray = players
		}
//		swapRef(side: paramsArray[0])	// update ref position
		updateFields(f: pTextArray)     // fill in player fields
		paramButton(posTypeOutlet)		// activate posession button
		paramButton(matchTypeOutlet)	// activate button to update display
		
		// Delegate control of keyboard to SetupMatchVC (or drag fields to VC-delegate in IB)
		p1Field.delegate = self; p2Field.delegate = self
        p3Field.delegate = self; p4Field.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	// Assign the newly active text field to your activeTextField variable
	func textFieldDidBeginEditing(_ textField: UITextField) {
		activeField = textField
		activeTag = textField.tag
		activeIndex = activeTag-1
		nextIndex = (matchTypeOutlet.selectedSegmentIndex==0 ? (activeIndex+1)%4 : (activeIndex+2)%4)	// for singles, skip a field
		nextTag = nextIndex+1
	}
	// Highlight next player field when pressing Enter (different for doubles or singles)
	@discardableResult		// avoid usage warning on Bool output when using
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// If the next field is default text, make it active on Return key
		if pFieldArray[nextIndex].text == "Player \(nextTag)" {
			textField.resignFirstResponder()
			pFieldArray[nextIndex].text! = ""
			pFieldArray[nextIndex].becomeFirstResponder()
			print("nextIndex \(nextIndex)")
		} else {
			resetBlankFields()			// check all fields (be sure to check all)
			savePlayers(pTextArray)		// save player names in defaults
			textField.resignFirstResponder()
		}
		return true
	}
    // Hide keyboard if touched outside of text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		resetBlankFields()			// check all fields (be sure to check all)
		savePlayers(pTextArray)		// save player names in defaults
		activeField.resignFirstResponder()
        self.view.endEditing(true)
    }
    // Pass new match object to MatchViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMatchVC" {
			let match: DoublesMatch
			if paramsArray[1]==0 {
				// Create doubles match, destination VC, and send it
				match = DoublesMatch(players: pTextArray, params: paramsArray)
			} else {
				pTextArray[1] = ""; pTextArray[3] = ""	// delete partners
				match = SinglesMatch(players: pTextArray, params: paramsArray)
			}
			
            let matchVC = segue.destination as! MatchViewController
			matchVC.match = match
        }
    }
}
