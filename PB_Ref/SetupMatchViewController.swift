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
    // mT = [0,1] for [Doubles,Singles]
    var mT = 0, nextField = 0, j = Int(), tField = UITextField()
    
    // Arrays
    let ipTextArray = ["Player 1","Player 2","Player 3","Player 4"]
    var pTextArray = [String]()
    var pFieldArray = [UITextField](), dImageArray = [UIImageView]()
    
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
    // Display default player names and update text array to them
    func resetPlayerFields() {
        for i in 0...3 {pFieldArray[i].text = ipTextArray[i]}
        pTextArray = ipTextArray
    }
    // Locate what field is being edited
    func selectedField(f: UITextField) -> Int {
        j = 0               // j saves the index of selected field
        for i in 0...3 {if f == pFieldArray[i] {j = i; break}}
        return j
    }
    
    /*-Buttons-------------------------------------------------------------*/
    // Unwind to Setup Match VC
    @IBAction func unwindToSetupMatch(segue: UIStoryboardSegue) {
    }
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
		swapRef(t: sender.selectedSegmentIndex)
	}
    @IBAction func matchTypeButton(_ sender: UISegmentedControl) {
        mT = sender.selectedSegmentIndex
        let show = (mT==0 ? false : true)
        showDoubles(show: show)
    }
    @IBAction func pointTypeButton(_ sender: UISegmentedControl) {
    }
    @IBAction func gameTypeButton(_ sender: UISegmentedControl) {
    }
	@IBAction func switchTypeButton(_ sender: UISegmentedControl) {
	}
    @IBAction func resetSetupButton(_ sender: UIButton) {
        // Reset court layout
        resetPlayerFields()
        showDoubles(show: false) // show doubles buttons & fields
        swapRef(t: 0)         // reset ref and serv dot
        
        // Reset buttons
		posTypeOutlet.selectedSegmentIndex = 0
		matchTypeOutlet.selectedSegmentIndex = 0
        pointTypeOutlet.selectedSegmentIndex = 0
        gameTypeOutlet.selectedSegmentIndex = 0
		switchTypeOutlet.selectedSegmentIndex = 0
    }
    @IBAction func startMatchButton(_ sender: UIButton) {
        // Create match from selected parameters
//        let playerList = [0,1,2,3].map({pFieldArray[$0].text})
        print("startMatchButton")
    }
    
    
    /*-Std Stuff-------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Arrays
        pTextArray = ipTextArray
        pFieldArray = [p1Field,p2Field,p3Field,p4Field]
        dImageArray = [d1Image,d2Image]
        
        resetPlayerFields()     // default player fields
		
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
        j = selectedField(f: textField)     // find # of selected field
        nextField = (mT==0 ? (j+1)%4 : (j+2)%4)   // for singles, skip a field
		
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
        resetBlankFields()    // if blank, replace with "Player X"
        self.view.endEditing(true)
    }
    // Pass new match object to MatchViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMatchVC" {
            // Save current parameters
			let p1 = posTypeOutlet.selectedSegmentIndex
            let p2 = matchTypeOutlet.selectedSegmentIndex
            let p3 = pointTypeOutlet.selectedSegmentIndex
            let p4 = gameTypeOutlet.selectedSegmentIndex
			let p5 = switchTypeOutlet.selectedSegmentIndex
            
            // Create match to pass on
			let match_0 = Match(p0: pTextArray, p1: p1, p2: p2, p3: p3, p4: p4, p5: p5)
			
			// Create destination VC for match_0
            let matchVC = segue.destination as! MatchViewController
			
            // Send match_0
            matchVC.match_0 = match_0
        }
    }
}
