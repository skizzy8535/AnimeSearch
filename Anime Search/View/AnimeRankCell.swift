//
//  AnimeRankCell.swift
//  Anime SearchTests
//
//  Created by 林祐辰 on 2021/1/1.
//

import UIKit

class AnimeRankCell: UITableViewCell {
    
    @IBOutlet weak var animeCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout, forRow row: Int) {
        
        animeCollection.delegate = dataSourceDelegate
        animeCollection.dataSource = dataSourceDelegate
        animeCollection.tag = row
        animeCollection.reloadData()
    }
    
    
}
