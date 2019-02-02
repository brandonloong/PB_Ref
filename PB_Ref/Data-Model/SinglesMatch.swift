//
//  SinglesMatch.swift
//  PB_Ref
//
//  Created by Brandon Loong on 1/16/19.
//  Copyright © 2019 Kayan. All rights reserved.
//

import Foundation

class SinglesMatch: DoublesMatch {
	
	override func newGame() {
		super.newGame()
		
		score = [0,0,1]
	}
	/*-Point Functions---------------------------------------------------------------------*/
	override func point() {
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
			print("point: game is over")
		}
	}
	// Switch player spots on both sides when point won
	override func swapPlayers() {
		playerSpots.swapAt(0,1)
		playerSpots.swapAt(2,3)
		playerNames = playerSpots.map( {playerList[$0]} ) // update names
	}
	
	override func fault() {
		if !gameOver {
			// Only 1 option for singles
			sideOut()
			
			// Create master array variable for all information to save state of match here
			rCount += 1
		} else {				// game is over
			print("fault_gameOver")
		}
	}
	override func sideOut() {
		super.sideOut()
		
		server = score[teamPos]%2 == 0 ? server : server+1
		
		let sumscores = score.reduce(0,+)
		if sumscores%2 ~= 0 {
			playerSpots = [1,0,3,2].map( {playerSpots[$0]} )	// switch players
			playerNames = playerSpots.map( {playerList[$0]} ) // update names
			print("Odd SideOut")
		}
	}
}
