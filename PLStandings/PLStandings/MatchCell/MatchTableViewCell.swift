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
    @IBOutlet weak var team1textField: UITextField!
    @IBOutlet weak var team2textField: UITextField!
    
    static let identifier = "MatchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MatchTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        team1textField.delegate = self
        team2textField.delegate = self
        
        team1textField.placeholder = "1"
        team2textField.placeholder = "2"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        team1textField.resignFirstResponder()
        team2textField.resignFirstResponder()
        print(textField.text ?? "")
        return true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
