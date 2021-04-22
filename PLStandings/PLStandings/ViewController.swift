//
//  ViewController.swift
//  PLStandings
//
//  Created by Adrian Minnich on 22/04/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var standings = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(TeamTableViewCell.nib(), forCellReuseIdentifier: TeamTableViewCell.identifier)

        title = "Standings"
        
        table.delegate = self
        table.dataSource = self
        
        getDataFromJSON()
    }
    
    func getDataFromJSON() {
        
        self.standings.removeAll()
        
        guard let fileLocation = Bundle.main.url(forResource: "currentStandings", withExtension: "json") else { return }
        
        var result: Standings?
        
        do {
            let data = try Data(contentsOf: fileLocation)
            result = try JSONDecoder().decode(Standings.self, from: data)
        }
        catch {
            print(error)
        }
        
        guard let finalResult = result else { return }
        self.standings.append(contentsOf: finalResult.teams)
        
        
        sortTeamsByPoints()
        assignPositionsToTeams()
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func sortTeamsByPoints() {
        self.standings = self.standings.sorted(by: {
            if $0.points != $1.points {
                return $0.points > $1.points
            }
            else {
                return $0.goalDiff > $1.goalDiff
            }
        })
    }
    
    func assignPositionsToTeams() {
        for i in 0..<self.standings.count {
            self.standings[i].setPosition(i+1)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return standings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier, for: indexPath) as! TeamTableViewCell
        cell.configure(with: standings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: TeamViewController.identifier) as! TeamViewController
        
        vc.title = "Team Info"
        vc.team = standings[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

struct Standings: Decodable {
    var teams: [Team]
}

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
