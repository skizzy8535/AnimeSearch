//
//  AnimeCollectionViewCell.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/1.
//

import UIKit

class AnimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animePictures: UIImageView!
    @IBOutlet weak var animeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        animePictures.layer.cornerRadius = 10.0
        
    }
}
