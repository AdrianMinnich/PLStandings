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
    let matches_played: Int
    let wins: Int
    let draws: Int
    let losses: Int
    let goals_scored: Int
    let goals_conceded: Int
    let points: Int
    let logo: String
    var position: Int = 0
    var goalDiff: Int { return goals_scored - goals_conceded }
    
    mutating func setPosition(_ pos: Int) {
        self.position = pos
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, short, matches_played, wins, draws, losses, goals_scored,
             goals_conceded, points, logo
    }
}
