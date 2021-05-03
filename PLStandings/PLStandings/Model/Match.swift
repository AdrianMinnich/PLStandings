//
//  Match.swift
//  PLStandings
//
//  Created by Adrian Minnich on 30/04/2021.
//

import Foundation

struct Match: Decodable {
    var id: Int
    var matchday: Int
    var home: String
    var away: String
    var date: String
    var homeTeam: Team?
    var awayTeam: Team?
    var homeResult: Int?
    var awayResult: Int?
    var homePoints: Int?
    var awayPoints: Int?
    var isResultEntered: Bool? = false
    var matchStatus: MATCH_STATUS = .NOT_PLAYED
    
    private enum CodingKeys: String, CodingKey {
        case id, matchday, home, away, date
    }
    
    enum MATCH_STATUS {
        case NOT_PLAYED
        case PLAYED
        case SAVED
    }
}
