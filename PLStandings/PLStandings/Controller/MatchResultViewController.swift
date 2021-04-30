//
//  MatchResultViewController.swift
//  PLStandings
//
//  Created by Adrian Minnich on 30/04/2021.
//

import UIKit

class MatchResultViewController: UIViewController, UITextFieldDelegate {
    
    var match: Match?
    

    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamResultLabel: UILabel!
    @IBOutlet weak var awayTeamResultLabel: UILabel!
    @IBOutlet weak var homeTeamResultTextField: UITextField!
    @IBOutlet weak var awayTeamResultTextField: UITextField!
    
    static let identifier = "MatchResultViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        self.homeTeamResultTextField.delegate = self
        self.awayTeamResultTextField.delegate = self
        
        self.homeTeamResultTextField.keyboardType = .numberPad
        self.awayTeamResultTextField.keyboardType = .numberPad
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func setup() {
        guard let match = match else { return }
        
        homeTeamNameLabel.text = match.homeTeam?.short
        awayTeamNameLabel.text = match.awayTeam?.short
        homeTeamImageView.image = UIImage(named: match.homeTeam?.logo ?? "")
        awayTeamImageView.image = UIImage(named: match.awayTeam?.logo ?? "")
    }
    
    @IBAction func didTapSave(_ sender: Any) {
    }
}
