//
//  RunLogCell.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/15/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {
//Outlets
    @IBOutlet weak var runDurationLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var averagePaceLbl: UILabel!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(run: Run) {
        runDurationLbl.text = run.duration.formatTimeDurationToString()
        totalDistanceLbl.text = "\(run.distance.metersToMiles(places: 2)) mi"
        averagePaceLbl.text = run.pace.formatTimeDurationToString()
        dateLbl.text = run.date.getDateString()
    }

}
