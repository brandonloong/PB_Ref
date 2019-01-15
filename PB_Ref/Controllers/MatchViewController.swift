//
//  MatchViewController.swift
//  PBRef
//
//  Created by Brandon Loong on 10/4/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
	// UI stuff
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var gameNumLabel: UILabel!
	@IBOutlet weak var s1Label: UILabel!; @IBOutlet weak var s2Label: UILabel!
	@IBOutlet weak var s3Label: UILabel!
	@IBOutlet weak var hrLabel: UILabel!; @IBOutlet weak var minLabel: UILabel!
	@IBOutlet weak var secLabel: UILabel!;
	@IBOutlet weak var p1Label: UILabel!; @IBOutlet weak var p2Label: UILabel!
	@IBOutlet weak var p3Label: UILabel!; @IBOutlet weak var p4Label: UILabel!
	@IBOutlet weak var p1DotImage: UIImageView!; @IBOutlet weak var p2DotImage: UIImageView!
	@IBOutlet weak var p3DotImage: UIImageView!; @IBOutlet weak var p4DotImage: UIImageView!
	@IBOutlet weak var courtImage: UIImageView!
	@IBOutlet weak var refImage: UIImageView!
	@IBOutlet weak var t1DotImage: UIImageView!; @IBOutlet weak var t2DotImage: UIImageView!
	@IBOutlet weak var t1RLabel: UILabel!; @IBOutlet weak var t2RLabel: UILabel!
	@IBOutlet weak var t1Runner: UILabel!; @IBOutlet weak var t2Runner: UILabel!
	@IBOutlet weak var t1G1Runner: UILabel!; @IBOutlet weak var t1G2Runner: UILabel!
	@IBOutlet weak var t1G3Runner: UILabel!; @IBOutlet weak var t1G4Runner: UILabel!
	@IBOutlet weak var t1G5Runner: UILabel!
	@IBOutlet weak var t2G1Runner: UILabel!; @IBOutlet weak var t2G2Runner: UILabel!
	@IBOutlet weak var t2G3Runner: UILabel!; @IBOutlet weak var t2G4Runner: UILabel!
	@IBOutlet weak var t2G5Runner: UILabel!
	@IBOutlet weak var t1TOLabel: UILabel!; @IBOutlet weak var t2TOLabel: UILabel!
	@IBOutlet weak var gameClockButtonOutlet: UIButton!
	
    // Variables
	var match = Match()		// create default match, later modified by SetupVC
    var matchType = 0, scoreType = 0, gameType = 0, posType = 0, gTime = [0,0,0]
    var gNum = 0, show = Int(), hide = Int(), team1 = Int(), team2 = Int(), toTime = Int()
	var timer1 = Timer(), timer2 = Timer(), timeOn = false
    // Arrays
    var scoreLabels = [UILabel](), playerLabels = [UILabel]()
	var serverDotImages = [UIImageView](), teamDotImages = [UIImageView]()
    var teamRunnerLabels = [UILabel](), teamRunners = [UILabel]()
	var gameRunners = [[UILabel]](), TOLabels = [UILabel]()
	// Other
	let timeOutAction3 = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
	}
	let timeOutAction4 = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
	}
	var timeOutAlert2 = UIAlertController()
    
	/*-Functions-------------------------------------------------------------*/
    // Try to make functions only change display items, not do computation or change values of variables
    
    // Unwind to Setup Match VC
    @IBAction func unwindToMatch(segue: UIStoryboardSegue) {
    }
	// Increase game clock timer
	@objc func increaseClock() {
		gTime[gNum] += 1		// increase gTime (total sec)
		// Int's automatically round down to floor, so no need to round min/hours
		secLabel.text = String(format: "%02d", gTime[gNum] % 60)	// update seconds label
		minLabel.text = String(format: "%02d", gTime[gNum]/60)		// update minutes label
		hrLabel.text = String(format: "%02d", gTime[gNum]/3600)		// update hours label
		//print("sec: " + secLabel.text! + ". gTime: \(gTime[gNum])")
	}
	// Stop game clock timer
	@objc func stopClock(_ sender: UIButton) {
		if !timeOn {
			sender.setTitle("Stop Clock", for: .normal)          // change button text
			timeOn = true          // stop clock on next click
			timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MatchViewController.increaseClock), userInfo: nil, repeats: true)
		} else {
			timer1.invalidate()			// stop the clock
			gameClockButtonOutlet.setTitle("Start Clock", for: .normal)	// change button text
			timeOn = false				// start clock on next click
		}
	}
	// Start timeout timer
	@objc func startTimeOut(t: Int) {
		let current = match.timeOuts[t]
		if current == 0 {
			timeOutAlert2 = UIAlertController(title: "Team \(t+1) is out of timeouts.", message: "Resume play", preferredStyle: .actionSheet)
			timeOutAlert2.addAction(timeOutAction4)
			present(timeOutAlert2, animated: true, completion: nil)
			print("No timeouts remain for this team. Continue play.")
		} else {
			match.timeOuts[t] = current-1
			toTime = 120		// 2 min timeout
			
			timeOutAlert2 = UIAlertController(title: "Timeout Countdown: 02:00", message: "Team \(t+1) has \(match.timeOuts[t]) timeouts left.", preferredStyle: .actionSheet)
			let timeOutAction5 = UIAlertAction(title: "Stop Timeout and Resume Play", style: .default) { (UIAlertAction) in
				self.timeOutInvalidate(tim: self.timer2, alert: self.timeOutAlert2)
			}
			timeOutAlert2.addAction(timeOutAction5)
			present(timeOutAlert2, animated: true, completion: nil)
			
			timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MatchViewController.decreaseTimeOut), userInfo: nil, repeats: true)
		}
	}
	// Increase timeout timer
	@objc func decreaseTimeOut() {
		if toTime > -1 {		// Timer continue
			let sec = String(format: "%02d", toTime % 60)	// update seconds label
			let min = String(format: "%02d", toTime / 60)	// update minutes label
			
			timeOutAlert2.title = "Timeout Countdown: "+"\(min)"+":"+"\(sec)"
			toTime -= 1
		} else {			// Timer finish
			timeOutInvalidate(tim: timer2, alert: timeOutAlert2)
			timeOutAlert2.dismiss(animated: true, completion: nil)
		}
	}
	func timeOutInvalidate(tim: Timer, alert: UIAlertController)  {
		tim.invalidate()
		alert.title = ""
		toTime = 120
	}
	// Update view based on current match data
	func updateView() {
		show = match.teamPos
		hide = (show+1)%2
		
		// Update game & score labels
		gameNumLabel.text = "Game \(match.gameIndex)"
		scoreLabels[0].text = String(match.score[show])
		scoreLabels[1].text = String(match.score[hide])
		scoreLabels[2].text = String(match.score[2])
		// Server dots
		for i in 0...3 {serverDotImages[i].isHidden = true}
		serverDotImages[match.server].isHidden = false
		// Player positions
		for i in 0...3 {playerLabels[i].text = match.playerNames[i]}
		// Referee direction
		refImage.image = UIImage(named: "tourny_ref_icon_vp\(match.sidePos)")
		
		// Update team, timeouts, & game score runners
		teamDotImages[show].isHidden = false		// show team stuff
		teamRunnerLabels[show].textColor = UIColor.black
		teamRunners[show].textColor = UIColor.black
		teamRunners[show].text = match.runnerText[show]
		TOLabels[show].text = "\(match.timeOuts[show])"
		teamDotImages[hide].isHidden = true			// hide team stuff
		teamRunnerLabels[hide].textColor = UIColor.gray
		teamRunners[hide].textColor = UIColor.gray
		teamRunners[hide].text = match.runnerText[hide]
		TOLabels[hide].text = "\(match.timeOuts[hide])"
		showGameRunners(game: match.gameIndex-1)
		
		print("updateView: show \(show), hide \(hide)")
	}
	func showGameRunners(game: Int) {
		gameRunners[show][game].text = "\(match.score[show])"
		gameRunners[hide][game].text = "\(match.score[hide])"
	}
	
    /*-Buttons-------------------------------------------------------------*/
    // Point button
	@IBAction func pointButton(_ sender: UIButton) {
		match.point()
		updateView()
    }
	// Fault button
	@IBAction func faultButton(_ sender: UIButton) {
		match.fault()
		updateView()
	}
	// Game clock button
	@IBAction func gameClockButton(_ sender: UIButton) {
		stopClock(sender)
	}
	// Timeout button
	@IBAction func timeOutButton(_ sender: UIButton) {
		let timeOutAlert1 = UIAlertController(title: "Which Team Called Timeout?", message: nil, preferredStyle: .alert)
		let timeOutAction1 = UIAlertAction(title: "Team 1:  \(match.playerList[0])--\(match.playerList[1])", style: .default) { (UIAlertAction) in
			self.startTimeOut(t: 0)
			
			print("timeOutButton: team 1")
			self.updateView()
		}
		let timeOutAction2 = UIAlertAction(title: "Team 2:  \(match.playerList[2])--\(match.playerList[3])", style: .default) { (UIAlertAction) in
			self.startTimeOut(t: 1)
			
			print("timeOutButton: team 1")
			self.updateView()
		}
		timeOutAlert1.addAction(timeOutAction1)
		timeOutAlert1.addAction(timeOutAction2)
		timeOutAlert1.addAction(timeOutAction3)
		present(timeOutAlert1, animated: true, completion: nil)
	}
	
    /*-Std Stuff-------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // UI arrays
        scoreLabels = [s1Label,s2Label,s3Label]
        playerLabels = [p1Label,p2Label,p3Label,p4Label]
        serverDotImages = [p1DotImage,p2DotImage,p3DotImage,p4DotImage]
        teamDotImages = [t1DotImage,t2DotImage]
        teamRunnerLabels = [t1RLabel,t2RLabel]
        teamRunners = [t1Runner,t2Runner]
		gameRunners = [[t1G1Runner,t1G2Runner,t1G3Runner,t1G4Runner,t1G5Runner],[t2G1Runner,t2G2Runner,t2G3Runner,t2G4Runner,t2G5Runner]]
        TOLabels = [t1TOLabel,t2TOLabel]
		
		updateView()
		print("New Match.posType: \(match.posType), matchType: \(match.matchType), pointType: \(match.pointType), gameType: \(match.gameType), switchType: \(match.switchType), players: \(match.playerNames)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "toMatchSumVC" {
//               let matchSumVC = segue.destination as! MatchSummaryViewController

               // Send game runners & info
//               matchSumVC.setRecord = setRecord; matchSumVC.winner = winner
//               matchSumVC.matchOver = matchOver; matchSumVC.ipTextArray = ipTextArray
          }
    }

}
