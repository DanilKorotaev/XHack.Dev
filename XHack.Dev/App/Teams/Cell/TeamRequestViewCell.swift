//
//  TeamRequestViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.04.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit


protocol TeamRequestViewCellDelegate {
    func apply(_ request: TeamRequest)
    func cancel(_ request: TeamRequest)
}

class TeamRequestViewCell: UITableViewCell {

    var delegate: TeamRequestViewCellDelegate?
    var model: TeamRequest?
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func set(_ model: TeamRequest) {
        self.model = model
        var teamText = ""
        if model.type == .userToTeam {
            typeLabel.text = "Outgoing request"
            teamText = "To team: "
            applyButton.isHidden = true
            cancelButton.setTitle("Withdraw", for: .normal)
        } else {
            typeLabel.text = "Incoming request"
            teamText = "To team: "
            applyButton.isHidden = false
            cancelButton.setTitle("Cancel", for: .normal)
        }
        teamLabel.text = teamText + model.team.name
    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        guard let request = model else { return }
        delegate?.apply(request)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        guard let request = model else { return }
        delegate?.cancel(request)
    }
}
