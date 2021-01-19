//
//  SearchTableViewCell.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/5.
//

import UIKit

class SearchTableViewCell: UITableViewCell {


    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultSearchName: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        resultImage.layer.cornerRadius = 10
        // Configure the view for the selected state
    }


    
    
    
    
    
    
    
}
