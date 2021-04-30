//
//  MatchViewController.swift
//  PLStandings
//
//  Created by Adrian Minnich on 23/04/2021.
//

import UIKit

class MatchViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var matches = [Match]()
    var standings = [Team]()
    
    static let identifier = "MatchViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(MatchTableViewCell.nib(), forCellReuseIdentifier: MatchTableViewCell.identifier)

        self.table.delegate = self
        self.table.dataSource = self

        getDataFromJSON()
        matches = assignTeamsForMatches()
    }
    
    func getDataFromJSON() {
        
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
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier, for: indexPath) as! MatchTableViewCell
        
        cell.matchDateLabel.text = matches[indexPath.row].date
        cell.team1Label.text = matches[indexPath.row].homeTeam?.short
        cell.team2Label.text = matches[indexPath.row].awayTeam?.short
        
        return cell
        
    }
    
    func assignTeamsForMatches() -> [Match]{
        
        for i in 0..<self.matches.count {
            self.matches[i].homeTeam = standings.first(where: { $0.logo == self.matches[i].home})
            self.matches[i].awayTeam = standings.first(where: { $0.logo == self.matches[i].away})
        }
        return self.matches
    }
}
