//
//  MatchResultViewController.swift
//  PLStandings
//
//  Created by Adrian Minnich on 30/04/2021.
//

import UIKit

protocol AddMatchResultDelegate {
    func addMatchResult(match: Match)
}

class MatchResultViewController: UIViewController, UITextFieldDelegate {
    
    var match: Match = Match(id: -1, matchday: -1, home: "", away: "", date: "")
    
    var delegate: AddMatchResultDelegate?
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamResultLabel: UILabel!
    @IBOutlet weak var awayTeamResultLabel: UILabel!
    @IBOutlet weak var homeTeamResultTextField: UITextField!
    @IBOutlet weak var awayTeamResultTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
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
        
        homeTeamResultTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        awayTeamResultTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        if match.matchStatus == .SAVED {
            disableTextFields()
            disableSaveButton()
        }
        else {
            enableTextFields()
            enableSaveButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeTeamResultTextField.becomeFirstResponder()
    }
    
    func setup() {
        
        homeTeamNameLabel.text = match.homeTeam?.short
        awayTeamNameLabel.text = match.awayTeam?.short
        homeTeamImageView.image = UIImage(named: match.homeTeam?.logo ?? "")
        awayTeamImageView.image = UIImage(named: match.awayTeam?.logo ?? "")
        
        if match.homeResult == nil {
            homeTeamResultLabel.text = ""
        }
        if match.awayResult == nil {
            awayTeamResultLabel.text = ""
        }
        guard let homeResult = match.homeResult,
              let awayResult = match.awayResult
        else {
            return
        }
        
        homeTeamResultLabel.text = "\(homeResult)"
        awayTeamResultLabel.text = "\(awayResult)"
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        
        showSavingAlert()
        
    }
    
    func showSavingAlert() {
        
        let msg = match.homeTeam!.short + " - " + match.awayTeam!.short
        
        let alert = UIAlertController(title: "Are you sure you want to save the result? You cannot change it later.",
                                      message: msg,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] action in
            
            match.homeResult = Int(homeTeamResultTextField.text ?? "0")
            match.awayResult = Int(awayTeamResultTextField.text ?? "0")
            
            
            match.matchStatus = .PLAYED
            match = calculatePoints()
            
            delegate?.addMatchResult(match: match)
            
            disableTextFields()
            disableSaveButton()
            
            homeTeamResultLabel.text = "\(match.homeResult ?? 0)"
            awayTeamResultLabel.text = "\(match.awayResult ?? 0)"

            
            let innerAlert = UIAlertController(title: "Operation succesfull", message: "", preferredStyle: .alert)
            innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                navigationController?.popViewController(animated: true)
            }))
            present(innerAlert, animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in print("cancel")
        }))
        
        present(alert, animated: true, completion: nil)
        return
    }
    
    func disableTextFields() {
        homeTeamResultTextField.isUserInteractionEnabled = false
        awayTeamResultTextField.isUserInteractionEnabled = false
        homeTeamResultTextField.backgroundColor = .lightGray
        awayTeamResultTextField.backgroundColor = .lightGray
    }
    
    func enableTextFields() {
        homeTeamResultTextField.isUserInteractionEnabled = true
        awayTeamResultTextField.isUserInteractionEnabled = true
        homeTeamResultTextField.backgroundColor = .white
        awayTeamResultTextField.backgroundColor = .white
    }
    
    func enableSaveButton() {
        saveButton.isEnabled = true
        saveButton.tintColor = .systemBlue
    }
    
    func disableSaveButton() {
        saveButton.isEnabled = false
        saveButton.tintColor = .lightGray
    }
    
    func calculatePoints() -> Match {
        guard let homeResult = self.match.homeResult,
              let awayResult = self.match.awayResult,
              var homeTeam = self.match.homeTeam,
              var awayTeam = self.match.awayTeam
        else { return self.match }
        
        if homeResult > awayResult {
            match.homePoints = 3
            match.awayPoints = 0
            match.homeTeam?.matches_played += 1
            match.awayTeam?.matches_played += 1
            match.homeTeam?.wins += 1
            match.awayTeam?.losses += 1
        }
        else if awayResult > homeResult {
            match.homePoints = 0
            match.awayPoints = 3
            match.homeTeam?.matches_played += 1
            match.awayTeam?.matches_played += 1
            match.homeTeam?.losses += 1
            match.awayTeam?.wins += 1
        }
        else if awayResult == homeResult {
            match.homePoints = 1
            match.awayPoints = 1
            match.homeTeam?.matches_played += 1
            match.awayTeam?.matches_played += 1
            match.homeTeam?.draws += 1
            match.awayTeam?.draws += 1
        }
        
        match.homeTeam!.points += (match.homePoints)!
        match.awayTeam!.points += (match.awayPoints)!
        
        return match
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text

            if text?.utf16.count == 1 {
                switch textField {
                case homeTeamResultTextField:
                    awayTeamResultTextField.becomeFirstResponder()
                case awayTeamResultTextField:
                    awayTeamResultTextField.resignFirstResponder()
                default:
                    break
                }
            }
    }
}
