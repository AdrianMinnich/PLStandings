//
//  Match.swift
//  PLStandings
//
//  Created by Adrian Minnich on 30/04/2021.
//

import Foundation

struct Match: Decodable {
    var matchday: Int
    var home: String
    var away: String
    var date: String
    var homeTeam: Team?
    var awayTeam: Team?
    
    private enum CodingKeys: String, CodingKey {
        case matchday, home, away, date
    }
}
