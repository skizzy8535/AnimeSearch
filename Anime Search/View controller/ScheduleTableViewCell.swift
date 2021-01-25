//
//  ScheduleTableViewCell.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var programImage: UIImageView!
    @IBOutlet weak var programName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
