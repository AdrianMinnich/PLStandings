//
//  MatchTableViewCell.swift
//  PLStandings
//
//  Created by Adrian Minnich on 23/04/2021.
//

import UIKit

class MatchTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var match: Match?

    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team1ResultLabel: UILabel!
    @IBOutlet weak var team2ResultLabel: UILabel!
    
    static let identifier = "MatchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MatchTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
