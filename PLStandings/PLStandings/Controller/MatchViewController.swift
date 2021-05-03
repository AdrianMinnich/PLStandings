//
//  MatchViewController.swift
//  PLStandings
//
//  Created by Adrian Minnich on 23/04/2021.
//

import UIKit

protocol PassDataDelegate {
    func passMatchesData(matches: [Match])
    func passStandingsData(standings: [Team])
}

class MatchViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var delegate: PassDataDelegate?
    
    var matches = [Match]()
    var standings = [Team]()
    
    static let identifier = "MatchViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(MatchTableViewCell.nib(), forCellReuseIdentifier: MatchTableViewCell.identifier)

        self.table.delegate = self
        self.table.dataSource = self

        matches = assignTeamsForMatches()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.standings = updateLeagueTable()
        delegate?.passMatchesData(matches: self.matches)
        delegate?.passStandingsData(standings: standings)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.standings = updateLeagueTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: MatchResultViewController.identifier) as! MatchResultViewController
        vc.match = matches[indexPath.row]
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier, for: indexPath) as! MatchTableViewCell
        
        cell.matchDateLabel.text = matches[indexPath.row].date
        cell.team1Label.text = matches[indexPath.row].homeTeam?.short
        cell.team2Label.text = matches[indexPath.row].awayTeam?.short
        
        cell.team1ResultLabel.text = "\(matches[indexPath.row].homeResult ?? -1)"
        cell.team2ResultLabel.text = "\(matches[indexPath.row].awayResult ?? -1)"
        
        if cell.team1ResultLabel.text == "-1" {
            cell.team1ResultLabel.text = ""
        }
        if cell.team2ResultLabel.text == "-1" {
            cell.team2ResultLabel.text = ""
        }
        return cell
    }
    
    func assignTeamsForMatches() -> [Match]{
        
        for i in 0..<self.matches.count {
            self.matches[i].homeTeam = standings.first(where: { $0.logo == self.matches[i].home})
            self.matches[i].awayTeam = standings.first(where: { $0.logo == self.matches[i].away})
        }
        return self.matches
    }
    
    func updateLeagueTable() -> [Team] {
        for i in 0..<matches.count {
            
            if matches[i].matchStatus == .PLAYED {
                
                matches[i].matchStatus = .SAVED
                
                guard let homePoints = matches[i].homePoints,
                      let awayPoints = matches[i].awayPoints,
                      let homeGoalsScored = matches[i].homeResult,
                      let homeGoalsConceded = matches[i].awayResult,
                      let awayGoalsScored = matches[i].awayResult,
                      let awayGoalsConceded = matches[i].homeResult
                else { return self.standings }
                
                print("UPDATE LEAGUE TABLE \(homePoints)")
                print("UPDATE LEAGUE TABLE \(awayPoints)")
                
                for j in 0..<standings.count {
                    if standings[j].short == matches[i].homeTeam!.short {
                        standings[j].points += homePoints
                        standings[j].goals_scored += homeGoalsScored
                        standings[j].goals_conceded += homeGoalsConceded
                        standings[j].setGoalDiff()
                        standings[j].matches_played = matches[i].homeTeam!.matches_played
                        standings[j].wins = matches[i].homeTeam!.wins
                        standings[j].draws = matches[i].homeTeam!.draws
                        standings[j].losses = matches[i].homeTeam!.losses
                    }
                    else if standings[j].short == matches[i].awayTeam!.short {
                        standings[j].points += awayPoints
                        standings[j].goals_scored += awayGoalsScored
                        standings[j].goals_conceded += awayGoalsConceded
                        standings[j].setGoalDiff()
                        standings[j].matches_played = matches[i].awayTeam!.matches_played
                        standings[j].wins = matches[i].awayTeam!.wins
                        standings[j].draws = matches[i].awayTeam!.draws
                        standings[j].losses = matches[i].awayTeam!.losses
                    }
                }
            }
        }
        return self.standings
    }
}

extension MatchViewController: AddMatchResultDelegate {
    func addMatchResult(match: Match) {
        
        for i in 0..<self.matches.count {
            if self.matches[i].id == match.id {
                self.matches[i] = match
                break
            }
        }
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
}
