//
//  Team.swift
//  PBRef
//
//  Created by Brandon Loong on 12/19/18.
//  Copyright © 2018 Kayan. All rights reserved.
//

struct Team {
    
    let startSide: Int?, seed: Int?, playerNames: [String]?
    var setScores = [Int]()
    //stats = [Int]()
    //var runner: [String]?, gameScore = [Int](),
    
    
    init(startSide: Int, seed: Int, playerNames: [String], setScores: [Int]) {
        self.startSide = startSide
        self.seed = seed
        self.playerNames = playerNames
        self.setScores = setScores
    }
    
}
