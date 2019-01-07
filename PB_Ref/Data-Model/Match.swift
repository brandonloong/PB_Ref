//
//  Match.swift
//  PBRef
//
//  Created by Brandon Loong on 12/21/18.
//  Copyright © 2018 Kayan. All rights reserved.
//
import UIKit

class Match {
    // New match parameters
    let playerList: [String], posType: Int, matchType: Int, pointType: Int
	let gameType: Int, switchType: Int
    let winScore: Int, winGame: Int, maxGame: Int, switchScore: Int
    let server0: Int?
    
	init(players: [String], params: [Int]) {
        playerList = players
		posType = params[0]
        matchType = params[1]
        pointType = params[2]
        gameType = params[3]
		switchType = params[4]
		
		// Calculate match parameters
		playerNames = playerList
		winScore = (pointType==0 ? 11 : 15)	// ending game score
		switchScore = (pointType==0 ? 6 : 8)
		winGame = gameType+1		// 1, 2, or 3 games needed for team to win
		maxGame = 2*gameType + 1	// 1, 3, or 5 games possible
		server0 = (posType==0 ? 0 : 2)		// initial server position
		
		// Calculate beginning match variables
		gamesWon = [0,0]
		gameIndex = 0
		switchedAlready = false
		matchOver = false
		
		// Create first game
		newGame()
    }
    
	// In-game variables
    var score = [Int](), server = Int(), sidePos = Int(), teamPos = Int()
	var rCount = Int(), playerSpots = [Int](), playerNames = [String]()
	var runnerText = [String](), switchedAlready = Bool(), clock = Int()
	// Between-game variables
    var gamesWon = [Int](), gameIndex = Int(), gameScores = [[Int]]()
	var gameTime = [Int](), matchWinner: Int?, runnerHistory = [[String]]()
	var rallyHistory = [Int](), diff = Int(), diffHistory = [Int]()
	var maxScore = Int(), show = Int(), hide = Int()
	var gameOver = Bool(), isOddGame = Bool()
	// Match variables
	var matchOver = Bool()
	
	/*----------------------------------------------------------------------*/
    func point() {
		if !gameOver {		// continue game
			//verify sidePos is set correctly before this is called
			score[teamPos] += 1
			pointRunnerText()
			swapPlayers()
			swapServer(side: sidePos)
			checkLastGame()
			checkGameOver()
			
			// Create master array variable for all information to save state of match here
			rCount += 1
		} else {			// game is over
			checkMatchOver()
			
			print("point()_gameOver")
		}
    }
	// Update runner text for adding a point with sideout character
	func pointRunnerText() {
		let txt = runnerText[teamPos]
		if txt.last == "/" {    // For 1st pt after a sideout: omit the starting space
			runnerText[teamPos] = txt + "\(score[teamPos])"
		} else {                // For adding point after that: start with a space
			runnerText[teamPos] = txt + " \(score[teamPos])"
		}
	}
	// Switch player spots on same side when serving team wins a point
	func swapPlayers() {
		if sidePos == 0 {  // swap left side
			playerSpots.swapAt(0,1)
		} else {        // swap right side
			playerSpots.swapAt(2,3)
		}
		playerNames = playerSpots.map( {playerList[$0]} ) // update names
	}
	// Change server to other position on the same side
	func swapServer(side: Int) {
		server = (side==0 ? (server+1)%2 : (server+1)%2+2) // swap 0-1 or 2-3
	}
	// Switch players sides midway through last game of match (if needed)
	func checkLastGame() {
		if switchType==0 {	// don't switch if switchType is off
			return
		}
		
		maxScore = max(score[0],score[1])
		if (gameIndex)==maxGame && maxScore==switchScore && !switchedAlready {
			switchedAlready = true  // disable future switches
			server = (server+2)%4   // move server to other side
			sidePos = (sidePos+1)%2	// move posession to other side
			swapSides()             // move player spots
			print("checkLastGame()_switch sides")
		}
	}
	// Rotate player spots: add 2 to every player spot mod 4
	func swapSides() {
		playerSpots = playerSpots.map { ($0 + 2)%4 }
		playerNames = playerSpots.map( {playerList[$0]} ) // update names
	}
	// Check if current game is over
	func checkGameOver() {
		maxScore = max(score[0],score[1])
		if maxScore >= winScore {
			diff = abs(score[0]-score[1])    // score differential
			if diff >= 2 {			// game won
				gameOver = true
				saveGame()			// Save game info
				print("checkGameOver()_game is over")
			}
		}
	}
	// Save game info
	func saveGame() {
		// Game specific data
		gameTime.append(clock)
		rallyHistory.append(rCount)
		diffHistory.append(diff)
		
		// Team specific data
		gamesWon[teamPos] += 1		// add game won to winning team
		gameScores.append([score[0],score[1]])
		runnerHistory.append(runnerText)
	}
	// Check if match is over
	func checkMatchOver() {
		if gamesWon[teamPos] == winGame { // match is over
			matchOver = true
			matchWinner = teamPos
			
			// Match Over popup
			let matchOverAlert = UIAlertController(title: "Match Over", message: "Team \(teamPos+1) Wins", preferredStyle: .alert)
			let restartNewMatch = UIAlertAction(title: "Restart Match", style: .default, handler: { (UIAlertAction) in self.newMatch()})
			let seeMatchSummary = UIAlertAction(title: "Match Statistics", style: .default) { (UIAlertAction) in
				//code
			}
			matchOverAlert.addAction(restartNewMatch)
			matchOverAlert.addAction(seeMatchSummary)
			
			print("checkMatchOver()_match is over. matchOver:\(matchOver), matchWinner:\(matchWinner!)")
		}
		else {			// next game
			// new game popover screen
			newGame()
		}
	}
	func newMatch() {
		
	}
	// Create a new game within the match
	func newGame() {
		gameIndex += 1			// increase game count
		
		// Reset all game stuff
		score = [0,0,2];			server = server0!
		sidePos = posType;			rCount = 0
		runnerText = [" 0"," 0"]//		clock = 0
		diff = 0;	maxScore = 0;	gameOver = false
		
		// Odd games [1,3,5], even game [2,4]
		if gameIndex%2 == 1 {		// odd game indices
			playerSpots = [0,1,2,3] // default spots
			isOddGame = true
			teamPos = 0
		} else {            		// even game indices
			playerSpots = [2,3,0,1] // switched spots
			isOddGame = false
			teamPos = 1
		}
		
		playerNames = playerSpots.map( {playerList[$0]} ) // update names
		print("NewGame(). score:\(score), server:\(server), sidePos:\(sidePos), gameIndex:\(gameIndex)")
	}
	/*----------------------------------------------------------------------*/
    func fault() {
		if !gameOver {		// continue game
			if score[2] == 1 {  // second server
				score[2] = 2
				swapServer(side: sidePos)
//				print("fault()_2nd server")
			} else {            // sideout
				sideOut()
//				print("fault()_sideout")
			}
			// create master array variable for all information to save state of match here
			rCount += 1
		} else {			// game is over
			print("fault()_gameOver")
		}
    }
    // Do sideout, move ball to other side
    func sideOut() {
        //score.swapAt(0,1)
        score[2] = 1
		sideOutRunner()
		sidePos = (sidePos+1)%2
		teamPos = (teamPos+1)%2
        server = (sidePos==0 ? 0 : 2)
    }
    // Update runner text for sideout before switching teamPos
    func sideOutRunner() {
        let txt = runnerText[teamPos]
        if txt.last != "/" {    // check for previous sideout char already
            runnerText[teamPos] = txt + "/"
        }
    }
}
