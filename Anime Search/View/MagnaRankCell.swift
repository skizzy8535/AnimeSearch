//
//  MagnaRankCell.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/3.
//

import UIKit

class MagnaRankCell: UITableViewCell {

    @IBOutlet weak var MagnaCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout, forRow row:Int ){
        MagnaCollection.delegate = dataSourceDelegate
        MagnaCollection.dataSource = dataSourceDelegate
        MagnaCollection.tag = row
        MagnaCollection.reloadData()
    }
}
