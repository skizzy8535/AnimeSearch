//
//  MagnaCollectionViewCell.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/3.
//

import UIKit

class MagnaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var MagnaImage: UIImageView!
    @IBOutlet weak var MagnaName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MagnaImage.layer.cornerRadius = 10.0
    }
    
}
