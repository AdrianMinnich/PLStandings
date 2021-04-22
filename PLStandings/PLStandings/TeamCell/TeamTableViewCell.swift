//
//  TeamTableViewCell.swift
//  PLStandings
//
//  Created by Adrian Minnich on 22/04/2021.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var matchesPlayedLabel: UILabel!
    @IBOutlet weak var goalDiffLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    static let identifier = "TeamTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TeamTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with team: Team) {
        
        positionLabel.text = "\(team.position)"
        logoImageView.image = UIImage(named: "\(team.logo)")
        logoImageView.contentMode = .scaleAspectFit
        teamNameLabel.text = team.name
        teamNameLabel.textAlignment = .left
        matchesPlayedLabel.text = "\(team.matches_played)"
        
        if team.goalDiff > 0 {
            goalDiffLabel.text = "+\(team.goalDiff)"
        }
        else {
            goalDiffLabel.text = "\(team.goalDiff)"
        }
        pointsLabel.text = "\(team.points)"
        
    }
}
