//
//  TeamViewController.swift
//  PLStandings
//
//  Created by Adrian Minnich on 22/04/2021.
//

import UIKit

class TeamViewController: UIViewController {

    var team: Team?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var drawsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var gsLabel: UILabel!
    @IBOutlet weak var gcLabel: UILabel!
    @IBOutlet weak var gdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showTeamDetails()
    }
    

    static let identifier = "TeamViewController"
    
    func showTeamDetails() {
        guard let team = team else { return }
        
        nameLabel.text = "\(team.name)"
        logoImageView.image = UIImage(named: "\(team.logo)")
        positionLabel.text = "\(team.position)"
        pointsLabel.text = "\(team.points)"
        matchesLabel.text = "\(team.matches_played)"
        winsLabel.text = "\(team.wins)"
        drawsLabel.text = "\(team.draws)"
        lossesLabel.text = "\(team.losses)"
        gsLabel.text = "\(team.goals_scored)"
        gcLabel.text = "\(team.goals_conceded)"
        guard let goalDiff = team.goalDiff else { return }
        gdLabel.text = "\(goalDiff)"
    }
}
