//
//  Team.swift
//  PLStandings
//
//  Created by Adrian Minnich on 30/04/2021.
//

import Foundation


struct Team: Decodable {
    let name: String
    let short: String
    var matches_played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var goals_scored: Int
    var goals_conceded: Int
    var points: Int
    let logo: String
    var position: Int = 0
    var goalDiff: Int? = 0
    
    mutating func setGoalDiff()  {
        self.goalDiff = goals_scored - goals_conceded
    }
    
    mutating func setPosition(_ pos: Int) {
        self.position = pos
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, short, matches_played, wins, draws, losses, goals_scored,
             goals_conceded, points, logo
    }
}
