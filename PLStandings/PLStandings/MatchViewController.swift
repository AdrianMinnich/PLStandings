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
    
    static let identifier = "MatchViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(MatchTableViewCell.nib(), forCellReuseIdentifier: MatchTableViewCell.identifier)
        table.allowsSelection = false
        self.table.delegate = self
        self.table.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))

        getDataFromJSON()
    }
    
    @objc func didTapSave() {
        
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier, for: indexPath) as! MatchTableViewCell
        
        cell.matchDateLabel.text = matches[indexPath.row].date
        cell.team1Label.text = matches[indexPath.row].home
        cell.team2Label.text = matches[indexPath.row].away
        
        return cell
        
    }

}

struct Fixtures: Decodable {
    var matches: [Match]
}

struct Match: Decodable {
    var matchday: Int
    var home: String
    var away: String
    var date: String
    
    private enum CodingKeys: String, CodingKey {
        case matchday, home, away, date
    }
}
