//
//  MatchViewController.swift
//  PBRef
//
//  Created by Brandon Loong on 10/4/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    
    // Labels, fields, images
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var s1Label: UILabel!; @IBOutlet weak var s2Label: UILabel!; @IBOutlet weak var s3Label: UILabel!
    @IBOutlet weak var p1Label: UILabel!; @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var p3Label: UILabel!; @IBOutlet weak var p4Label: UILabel!
    @IBOutlet weak var p1DotImage: UIImageView!; @IBOutlet weak var p2DotImage: UIImageView!
    @IBOutlet weak var p3DotImage: UIImageView!; @IBOutlet weak var p4DotImage: UIImageView!
    @IBOutlet weak var courtImage: UIImageView!
    @IBOutlet weak var refImage: UIImageView!
    @IBOutlet weak var t1DotImage: UIImageView!; @IBOutlet weak var t2DotImage: UIImageView!
    @IBOutlet weak var t1RLabel: UILabel!; @IBOutlet weak var t2RLabel: UILabel!
    @IBOutlet weak var t1Runner: UILabel!; @IBOutlet weak var t2Runner: UILabel!
    @IBOutlet weak var t1G1Runner: UILabel!; @IBOutlet weak var t1G2Runner: UILabel!; @IBOutlet weak var t1G3Runner: UILabel!
    @IBOutlet weak var t2G1Runner: UILabel!; @IBOutlet weak var t2G2Runner: UILabel!; @IBOutlet weak var t2G3Runner: UILabel!
    @IBOutlet weak var t1TOLabel: UILabel!; @IBOutlet weak var t2TOLabel: UILabel!
    
    // Variables
	// DS=0 is 'Doubles' [0,1], scoreType=0 is 3 games [0,2], iserv=0 is p1 [0-3]
	// tScore order is [left,right,server], not [Team1,Team2,server] (it alternates which team is tScore[0] each game)
	// p is which side (not team) possesses the ball
	var DS = 0, scoreType = 0, serv = 0, iserv = 0
    var ptxt = "", phtxt = "", txt = "", schar = "/", matchOver = false, evenG = false, thirdGameOccur = false
    var ipos = 0, p = 0, p2 = 0, tScore = [0,0,2], gNum = 0, rCount = 0
    var endSet = 0, endScore = 0, numGame = [0,0], tag = 0, mScore = 0, switchScore = 0
    
    // Arrays
    var sLabels = [UILabel]()
    var pLabels = [UILabel](), pDImages = [UIImageView](), tDImages = [UIImageView]()
    var ipTextArray = ["","","",""], pTextArray = ["","","",""]
    var tRLabels = [UILabel](), tRunners = [UILabel](), t1GRunners = [UILabel](), t2GRunners = [UILabel]()
    var TOLabels = [UILabel]()
	var setRecord = [String]()
    var setArray = Array(repeating: [0,0,0], count: 2)    // row 1 Team 1, row 2 Team 2
    
    /*------------------------------------------------------------------------------------------------*/
    // Functions
    // Try to make functions only change display items, not do computation or change values of variables
    
    // Unwind to Setup Match VC
    @IBAction func unwindToMatch(segue: UIStoryboardSegue) {
    }
    // Switch player dot on same side
    func switchPDot() {
        for i in 0...3 {pDImages[i].isHidden = true}    // hide all pDots
        if serv == 0 {pDImages[0].isHidden = false}
        else if serv == 1 {pDImages[1].isHidden = false}
        else if serv == 2 {pDImages[2].isHidden = false}
        else {pDImages[3].isHidden = false}
    }
    // Switch players on side p
    func switchPlayers() {
        if p == 0 {     // swap left side
            ptxt = pLabels[0].text!; pLabels[0].text = pLabels[1].text; pLabels[1].text = ptxt
        } else {        // swap right side
            ptxt = pLabels[2].text!; pLabels[2].text = pLabels[3].text; pLabels[3].text = ptxt
        }
    }
    // Switch team sides
    func switchSides() {
        for i in 0...3 {pTextArray[i] = pLabels[i].text!}       // save all current positions
        for i in 0...3 {pLabels[(i+2)%4].text = pTextArray[i]}  // rotate all players by 2 spots clockwise from their current positions
    }
    // Highlight which runner has possession during each game
    func highlightRunner() {
        //print("highlightRunner0 tScore: \(tScore), p: \(p), serv: \(serv), gNum: \(gNum)") // testing
        if !evenG {    // 1st game or first half of 3rd game (don't use gNum%2 b/c 3rd game uses both evenG vals)
            tRunners[p].textColor = UIColor.black; tRLabels[p].textColor = UIColor.black // emphasize p runner/label/dot
            tDImages[p].isHidden = false        // show Team p dot
            if p == 0 {     // de-emphasize Team 2 runner/label/dot
                tRunners[1].textColor = UIColor.gray; tRLabels[1].textColor = UIColor.gray
                tDImages[1].isHidden = true;    // hide Team 2 dot
            }
            else {          // de-emphasize Team 1 runner/label/dot
                tRunners[0].textColor = UIColor.gray; tRLabels[0].textColor = UIColor.gray
                tDImages[0].isHidden = true;    // hide Team 1 dot
            }
            //print("highlightRunnerG1-3 tScore: \(tScore), p: \(p), serv: \(serv), gNum: \(gNum)") // testing
        } else {            // 2nd game
            tRunners[p].textColor = UIColor.gray; tRLabels[p].textColor = UIColor.gray  // de-emphasize !p runner/label/dot
            tDImages[p].isHidden = true;
            if p == 0 {     // emphasize Team 2 runner/label/dot
                tRunners[1].textColor = UIColor.black; tRLabels[1].textColor = UIColor.black
                tDImages[1].isHidden = false
            }
            else {          // emphasize Team 1 runner/label/dot
                tRunners[0].textColor = UIColor.black; tRLabels[0].textColor = UIColor.black
                tDImages[0].isHidden = false
            }
            //print("highlightRunnerG2 tScore: \(tScore), p: \(p), serv: \(serv), gNum: \(gNum)") // testing
        }
    }
    // Switch ref facing direction and make p1/p3 dot show
    func switchRef() {
        // Ref always follows p, for any game
        if p == 0 {       // ref on left, dot on p1/left team
            refImage.image = UIImage(named: "tourny_ref_icon_v2.png")
            for i in 0...3 {pDImages[i].isHidden = true}; pDImages[0].isHidden = false
        }
        else {              // ref on right, dot on p3/right team
            refImage.image = UIImage(named: "tourny_ref_icon_v3.png")
            for i in 0...3 {pDImages[i].isHidden = true}; pDImages[2].isHidden = false
        }
        highlightRunner()
        //print("switchRef0 tScore: \(tScore), p: \(p), serv: \(serv), gNum: \(gNum)") // testing
    }
    // Append "add text" to "old text" to make "new text"
    func appRText(ot: String, at: String) -> String {
        let newText = ot + at
        return newText
    }
    // Update score labels once p & tScore are up
    func updateScore() {
        if p2 == 0 {	// put left score first
            sLabels[0].text = String(tScore[0]); sLabels[1].text = String(tScore[1]);
        } else {        // put right score first
            sLabels[0].text = String(tScore[1]); sLabels[1].text = String(tScore[0]);
        }
        sLabels[2].text = String(tScore[2]);
    }
    // Update match view title
    func updateTitle(ot: String, at: String) {
    }
    // Update runner text for adding a point
	func pointRunner() {
		txt = tRunners[p2].text!
		if String(txt.last!) == schar {		// For 1st pt after a sideout: omit the starting space
			tRunners[p2].text! = appRText(ot: txt, at: "\(tScore[p2])")
		} else {                            // For adding point after that: start with a space
			tRunners[p2].text! = appRText(ot: txt, at: " \(tScore[p2])")
		}
    }
    // Update runner text for a sideout by adding schar
    func sideOutRunner() {
        txt = tRunners[p2].text!
        if String(txt.last!) == schar {}   // don't use 'return' here
        else {tRunners[p2].text = appRText(ot: txt, at: schar)}
    }
    // Change server location to his next position if server is staying on same side
    func updateServ() {
        if serv == 0 {serv = 1}
        else if serv == 1 {serv = 0}
        else if serv == 2 {serv = 3}
        else {serv = 2}
    }
    // Create a new game, based on parameters (gNum, ipos)
    func newGame() {
        for i in 0...3 {pDImages[i].isHidden = true}    // hide all serve dots except initial serv position (every game)
        pDImages[iserv].isHidden = false; serv = iserv  // serv is initial server, always
        if serv == 0 {p = 0}  // left possession
        else {p = 1}          // right possession
        
        // Position players depending on gNum
        if (gNum%2) == 0 {    // 1st & 3rd game
			evenG = false
			for i in 0...3 {
               pLabels[i].text = ipTextArray[i]        // players are in initial positions
          	}
        } else {              // 2nd game
			evenG = true
			for i in 0...3 {
               pLabels[(i+2)%4].text = ipTextArray[i]  // players are in opposite positions
          	}
        }
        
        switchRef()         // switchRef that direction & highlightRunner (in switchRef)
        tScore = [0,0,2];   // reset tScore
		viewTitle.text = "Game \(gNum+1)"	// update game number
        for i in 0...2 {sLabels[i].text = "\(tScore[i])"}					// reset scoreLabels
        for i in 0...1 {tRunners[i].text = " 0"; TOLabels[i].text = "2"}    // reset runner & time-outs
    }
	// 3rd game change over halfway through
	func thirdGameSwitch() {
		// 3rd set half switch: only enable 1 time with thirdGameOccur
		if gNum == endSet && max(tScore[0], tScore[1]) == switchScore && !thirdGameOccur {
			evenG = true		// treat scoring as if it were an even game now
			pDImages[serv].isHidden = true;		// hide serve dot at old location
			serv = (serv+2) % 4					// new serve location
			if serv == 0 || serv == 1 {p = 0; p2 = 1}	// update p for new serv location
			else{p = 1; p2 = 0}		// treat scoring/highlighting like even games using flipped p2
			
			pDImages[serv].isHidden = false;	// show serve dot at new location
			for i in 0...3 {pTextArray[i] = pLabels[i].text!}		// save all current player labels
			for i in 0...3 {pLabels[(i+2)%4].text = pTextArray[i]}	// rotate players
			switchRef()         // switchRef that direction & highlightRunner (in switchRef)
			
			thirdGameOccur = true;
			//print("thirdGameSwitch(): \(setArray), gNum: \(gNum), serv: \(serv), p: \(p), p2: \(p2)") // testing
		}
	}
    // Check if game over
    func gameCheck() {
        mScore = max(tScore[0], tScore[1])
        
        if mScore >= endScore {              // mScore > endScore
            let diff = tScore[0] - tScore[1] // check if teams are within 2 points
            if abs(diff) >= 2 {              // new game
                numGame[p2] = numGame[p2] + 1  // award game to winning team
                
                // Save final game score for each team
                setArray[0][gNum] = tScore[0];    setArray[1][gNum] = tScore[1]
                t1GRunners[gNum].text = "\(tScore[0])";     t2GRunners[gNum].text = "\(tScore[1])"
                
                // Update view title & game runners
                gNum = gNum + 1
                viewTitle.text = "Game \(gNum+1)"
                
                if numGame[p2] == endSet {		// MATCH OVER
                    matchOver = true			// disable point buttons
                    viewTitle.text = "Match Over: Team \(p2+1) Wins"
                    refImage.image = UIImage(named: "tourny_ref_icon_v1.png")
                    
                    print("gameCheck/MatchOver: \(setArray), gNum: \(gNum), endSet: \(endSet)") // testing
                }
                else {                       // NEXT GAME
                    newGame()                // initialize new game
                    print("gameCheck/NextGame: \(setArray), gNum: \(gNum), endSet: \(endSet)") // testing
                }
            }
        }
    }
    
    /*------------------------------------------------------------------------------------------------*/
    // Buttons
    
    // Who won rally?
    @IBAction func pointButton(_ sender: UIButton) {
        tag = sender.tag
        if matchOver {return}       // MATCH OVER disable any button
		
        if tag == p {               // ADD POINT
          	//print("AddPoint0: \(setArray), gNum: \(gNum), serv: \(serv), p: \(p), p2: \(p2)") // testing
			if !evenG {p2 = p}		// odd games, no change
		   	else {					// even games, switch which runner is modified
			   	if p == 0 {p2 = 1}
			   	else {p2 = 0}
		   	}
		   	tScore[p2] = tScore[p2] + 1
		   	updateServ()    	// update serv to next spot on same side
		   	updateScore()   	// update score labels
		   	pointRunner()   	// update runner p with latest score
		   	switchPDot()    	// have playerDot show on new server
		   	switchPlayers() 	// swap serving team positions based on p, not p2
			thirdGameSwitch()	// check for switchover on 3rd game
		   	gameCheck()    		// check if game is over
			
			//print("AddPoint1: \(setArray), gNum: \(gNum), serv: \(serv), p: \(p), p2: \(p2)") // testing
			
        } else {
            if tScore[2] == 1 {     // 2ND SERVER
                tScore[2] = 2
                updateServ()    // update serv to next spot on same side
                switchPDot()    // have playerDot show on new server
                updateScore()   // update score labels
                
                print("2ndServ tScore: \(tScore), p: \(p), serv: \(serv)") // testing
                
            } else {                // SIDEOUT
                //print("AddPoint, tScore: \(tScore), p: \(p), serv: \(serv), iserv: \(iserv)")
                tScore[2] = 1
                sideOutRunner()         // update runner for team on side p before sideout
                if p == 0 {serv = 2}    // update serv for sideout
                else {serv = 0}
				
				p = tag			// switch p
				if evenG {		// switch p2 for evenG condition
					if p == 0 {p2 = 1}
					else {p2 = 0}
				}
                switchPDot()    // have playerDot show on new server
                updateScore()   // update score labels
                switchRef()     // switch ref direction
                
                print("Sideout tScore: \(tScore), p: \(p), serv: \(serv)") // testing
            }
        }
        rCount += 1
        print("rCount = \(rCount)") // testing
    }
	
	
	
    
    /*------------------------------------------------------------------------------------------------*/
    // Standard stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Create arrays
        sLabels = [s1Label,s2Label,s3Label];
        pLabels = [p1Label,p2Label,p3Label,p4Label]
        pDImages = [p1DotImage,p2DotImage,p3DotImage,p4DotImage]
        tDImages = [t1DotImage,t2DotImage]
        tRLabels = [t1RLabel,t2RLabel];     tRunners = [t1Runner,t2Runner];
        t1GRunners = [t1G1Runner,t1G2Runner,t1G3Runner];    t2GRunners = [t2G1Runner,t2G2Runner,t2G3Runner]
        TOLabels = [t1TOLabel,t1TOLabel]
        
        // Initial parameters from SetupMatchViewController
		if scoreType == 0 {endSet = 2; endScore = 11; switchScore = 6}
		else if scoreType == 1 {endSet = 1; endScore = 15; switchScore = 8}
		else {endSet = 1; endScore = 11; switchScore = 6}
        
        // Start 1st game
        newGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
