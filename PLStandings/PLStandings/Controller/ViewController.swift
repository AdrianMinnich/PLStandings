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
    var matches = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(TeamTableViewCell.nib(), forCellReuseIdentifier: TeamTableViewCell.identifier)

        title = "Standings"
        
        table.delegate = self
        table.dataSource = self
        
        getTeamsDataFromJSON()
        getMatchdaysDataFromJSON()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sortTeamsByPoints()
        assignPositionsToTeams()
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func getTeamsDataFromJSON() {
        
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
        
        for i in 0..<standings.count {
            standings[i].setGoalDiff()
        }
        
        sortTeamsByPoints()
        assignPositionsToTeams()
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func getMatchdaysDataFromJSON() {
        
        guard let fileLocation = Bundle.main.url(forResource: "matchdays", withExtension: "json") else { return }
        
        var result: Fixtures?
        
        do {
            let data = try Data(contentsOf: fileLocation)
            result = try JSONDecoder().decode(Fixtures.self, from: data)
        }
        catch {
            print(error)
        }
        
        guard let finalResult = result else { return }
        self.matches.append(contentsOf: finalResult.matches)
        
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
                return $0.goalDiff! > $1.goalDiff!
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: TeamViewController.identifier) as! TeamViewController
        
        vc.title = "Team Info"
        vc.team = standings[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    @IBAction func didTapMatchdays(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: MatchViewController.identifier) as! MatchViewController
        
        vc.title = "Results"
        vc.delegate = self
        vc.standings = self.standings
        vc.matches = self.matches
        
        navigationController?.pushViewController(vc, animated: true)
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
}

extension ViewController: PassDataDelegate {
    func passMatchesData(matches: [Match]) {
        self.matches = matches
        
        /*DispatchQueue.main.async {
            self.table.reloadData()
        }*/
    }
    
    func passStandingsData(standings: [Team]) {
        self.standings = standings
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
}
