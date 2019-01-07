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
    @IBOutlet weak var p1Field: UITextField!;   @IBOutlet weak var p2Field: UITextField!
    @IBOutlet weak var p3Field: UITextField!;   @IBOutlet weak var p4Field: UITextField!
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
    var t = Int(), nextField = 0, j = Int(), tField = UITextField()
    // Arrays
    let ipTextArray = ["Player 1","Player 2","Player 3","Player 4"]
    var pTextArray = [String](), resetArray = [0,0,0,0,0]
	var defaultArray = [Int]()
    var pFieldArray = [UITextField](), dImageArray = [UIImageView]()
	// UserDefaults for saving match preferences
	let matchDefaults = UserDefaults.standard
	
    /*-Functions-------------------------------------------------------------*/
    // Switch player spots on same side when serving team wins a point
    func swapSpots(t: Int) {
        if t == 0 {     // swap left side
            pTextArray.swapAt(0,1)
        } else {        // swap right side
            pTextArray.swapAt(2,3)
        }
    }
    // Rotate player spots: add 2 to every player spot mod 4
    func swapSides() {
        pTextArray = [2,3,0,1].map({pTextArray[$0]})  // rotate player fields
    }
    // Switch ref facing direction and serv dot
    func swapRef(t: Int) {
        let show = (t==0 ? 0 : 1)
        let hide = (t==1 ? 0 : 1)
        
        dImageArray[show].isHidden = false
        dImageArray[hide].isHidden = true
        refImage.image = UIImage(named: "tourny_ref_icon_vp\(t).png")
    }
    // Update player names
    func updatePlayerFields(f: [String]) {
        for i in 0...3 {pFieldArray[i].text = f[i]}
    }
    // Save player names from display into the text array
    func getPlayers() {
        for i in 0...3 {pTextArray[i] = pFieldArray[i].text!}
    }
    // Display the doubles partner fields and the doubles buttons
    func showDoubles(show: Bool) {
        p2Field.isHidden = show
        p4Field.isHidden = show
        swap0ButtonOutlet.isHidden = show
        swap1ButtonOutlet.isHidden = show
    }
    // If a player field is ever left blank, add text "Player X"
    func resetBlankFields() {
        for i in 0...3 {
            if pFieldArray[i].text == "" {
                let fill = "Player \(i+1)"
                pFieldArray[i].text = fill
                pTextArray[i] = fill
            }
        }
    }
    // Reset player fields
    func resetPlayerFields() {
        for i in 0...3 {pFieldArray[i].text = ipTextArray[i]}
        pTextArray = ipTextArray
    }
	// Default player fields
//	func defaultPlayerFields() {
//		for i in 0...3 {pFieldArray[i].text = ipTextArray[i]}
//		pTextArray = ipTextArray
//	}
    // Locate what field is being edited
    func selectedField(f: UITextField) -> Int {
        j = 0               // j saves the index of selected field
        for i in 0...3 {if f == pFieldArray[i] {j = i; break}}
        return j
    }
	// Update buttons to specified values
	func updateButtons(params: [Int]) {
		posTypeOutlet.selectedSegmentIndex = params[0]
		matchTypeOutlet.selectedSegmentIndex = params[1]
		pointTypeOutlet.selectedSegmentIndex = params[2]
		gameTypeOutlet.selectedSegmentIndex = params[3]
		switchTypeOutlet.selectedSegmentIndex = params[4]
	}
    
    /*-Buttons-------------------------------------------------------------*/
    // Unwind to Setup Match VC
    @IBAction func unwindToSetupMatch(segue: UIStoryboardSegue) {}
    @IBAction func swapButton(_ sender: UIButton) {
        let s = sender.tag
        if s != 2 {     // swap players
            swapSpots(t: s)
        } else {        // swap sides
            swapSides()
        }
        updatePlayerFields(f: pTextArray)
    }
	@IBAction func posTypeButton(_ sender: UISegmentedControl) {
		t = sender.selectedSegmentIndex
		swapRef(t: t)
//		defaultArray[0] = t
//		matchDefaults.set(defaultArray, forKey: "defaultMatch")
	}
    @IBAction func matchTypeButton(_ sender: UISegmentedControl) {
        t = sender.selectedSegmentIndex
        let show = (t==0 ? false : true)
        showDoubles(show: show)
//		defaultArray[1] = t
//		matchDefaults.set(defaultArray, forKey: "defaultMatch")
    }
    @IBAction func pointTypeButton(_ sender: UISegmentedControl) {
//		t = sender.selectedSegmentIndex
//		defaultArray[2] = t
//		matchDefaults.set(defaultArray, forKey: "defaultMatch")
	}
    @IBAction func gameTypeButton(_ sender: UISegmentedControl) {
//		t = sender.selectedSegmentIndex
//		defaultArray[3] = t
//		matchDefaults.set(defaultArray, forKey: "defaultMatch")
	}
	@IBAction func switchTypeButton(_ sender: UISegmentedControl) {
//		t = sender.selectedSegmentIndex
//		defaultArray[4] = t
//		matchDefaults.set(defaultArray, forKey: "defaultMatch")
	}
    @IBAction func resetSetupButton(_ sender: UIButton) {
        resetPlayerFields()			// reset player fields
        showDoubles(show: false)	// show doubles buttons & fields
        swapRef(t: 0)         		// reset ref and serv dot
		updateButtons(params: resetArray)	// reset button values
    }
    @IBAction func startMatchButton(_ sender: UIButton) {}
    
    
    /*-Std Stuff-------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Arrays
        pTextArray = ipTextArray
        pFieldArray = [p1Field,p2Field,p3Field,p4Field]
        dImageArray = [d1Image,d2Image]
        
        resetPlayerFields()     // default player fields
		
		// Update view with last selected parameters from UserDefaults
		if let defaultArray = matchDefaults.array(forKey: "defaultMatch") as? [Int] {
			updateButtons(params: defaultArray)
		}
		
		// Delegate control of keyboard to SetupMatchVC
        // Can do this in InterfaceBuilder by dragging fields to VC-delegate
		p1Field.delegate = self; p2Field.delegate = self
        p3Field.delegate = self; p4Field.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	// Highlight next player field when pressing Enter (different for doubles or singles)
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        j = selectedField(f: textField)     	// find # of selected field
        nextField = (t==0 ? (j+1)%4 : (j+2)%4)	// for singles, skip a field
		
		if pFieldArray[nextField].text == "Player \(nextField)" {	// if the next field is default text, make that active on Return key
			textField.resignFirstResponder()
			pFieldArray[nextField].becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
        
        resetBlankFields()    // reset "Player X" names
        pTextArray[j] = textField.text!
		return true
	}
    // Hide keyboard if touched outside of text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		resetBlankFields()    // if blank, replace with "Player #"
        self.view.endEditing(true)
    }
    // Pass new match object to MatchViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMatchVC" {
            // Get current parameters
			let p1 = posTypeOutlet.selectedSegmentIndex
            let p2 = matchTypeOutlet.selectedSegmentIndex
            let p3 = pointTypeOutlet.selectedSegmentIndex
            let p4 = gameTypeOutlet.selectedSegmentIndex
			let p5 = switchTypeOutlet.selectedSegmentIndex
			
//			if p2==1 {
//				pTextArray[1] = ""
//				pTextArray[3] = ""
//			}
			
			// Save them to persistent UserDefaults
			defaultArray = [p1,p2,p3,p4,p5]
			matchDefaults.set(defaultArray, forKey: "defaultMatch")
			
            // Create match, destination VC, and send it
			let match_0 = Match(players: pTextArray, params: defaultArray)
//			let match = Match(players: pTextArray, params: defaultArray)
            let matchVC = segue.destination as! MatchViewController
            matchVC.match_0 = match_0
//			matchVC.match = match
        }
    }
}
