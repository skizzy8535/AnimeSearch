//
//  RankMagnaViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/1.
//

import UIKit
import SafariServices

enum RankMagna:Int {
    case topRankedMagna
    case topOneShotsMagna
    case topDoujinMagna
    static var numberOfSections: Int { return 3 }
}

class RankMagnaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MagnaTableView: UITableView!
    var query = "top"
    var type = "manga"
    var page = 1
    var subtype:String? = "favorite"
    
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask :URLSessionDataTask?
    let loadingIndicator = UIActivityIndicatorView()
    
    var topRankedArray = [AnimeData]()
    var topOneShotsArray = [AnimeData]()
    var topDoujinArray = [AnimeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MagnaTableView.delegate = self
        self.MagnaTableView.dataSource = self
        loadingIndicator.color = .systemRed
        loadingIndicator.startAnimating()
        setupLoadingIndicator()
        getTopRankedMagna()
        getTopOneShotsMagna()
        getTopDoujinMagna()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoadingIndicator()
    }
    
    func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        let horizontalConstraint = NSLayoutConstraint(item: loadingIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: loadingIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    func getTopRankedMagna(){
        MagnaTableView.isHidden = true
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: {[self] (topAnime, error) in
            self.downloadTask = nil
            if error != nil{
                DispatchQueue.main.async {
                    errorMessage()
                }
            }
            
            if let topItem = topAnime?.top{
                self.topRankedArray.append(contentsOf:topItem)
                DispatchQueue.main.async {
                    self.MagnaTableView.reloadData()
                }
            }
        })
        
    }

    func getTopOneShotsMagna(){
        subtype = "oneshots"
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: { [self] (topAnime, error) in
            self.downloadTask = nil
            
            if error != nil{
                DispatchQueue.main.async {
                    errorMessage()
                }
            }
            
            if let oneshotsItem = topAnime?.top{
                self.topOneShotsArray.append(contentsOf:oneshotsItem)
                DispatchQueue.main.async {
                    self.MagnaTableView.reloadData()
                }
            }
        })
    }
    
    func getTopDoujinMagna(){
        subtype = "doujin"
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: { [self] (topAnime, error) in
            self.downloadTask = nil
            if error != nil{
                DispatchQueue.main.async {
                    errorMessage()
                }
            }
            
            if let doujinItem = topAnime?.top{
                self.topDoujinArray+=doujinItem
                DispatchQueue.main.async {
                    self.MagnaTableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                    self.MagnaTableView.isHidden = false
                
                }
            }
         })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        RankMagna.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MagnaTableView.dequeueReusableCell(withIdentifier: "magnaCell", for: indexPath) as? MagnaRankCell
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let magnaRankCell = cell as? MagnaRankCell else { return}
        magnaRankCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 10, y: 13, width: 250, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        
        switch RankMagna(rawValue: section) {
        case .topRankedMagna :
            label.text = "Top Ranked Magna"
            label.textColor = .black
        case .topOneShotsMagna :
            label.text = "Top Oneshots Magna"
            label.textColor = .black
        case .topDoujinMagna :
            label.text = "Top Doujin Magna"
            label.textColor = .black
        default:
            label.text = "No Magna Data"
        }
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func errorMessage(){
        let alertController = UIAlertController(title: "Error", message: "Can't load Anime Item", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension RankMagnaViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch RankMagna(rawValue: section){
        case .topRankedMagna:
            return topRankedArray.count
        case .topOneShotsMagna:
            return topOneShotsArray.count
        case .topDoujinMagna:
            return topDoujinArray.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "magnaCollectionViewCell", for: indexPath) as? MagnaCollectionViewCell
        var topElement: AnimeData
     
        if topRankedArray.count != 0 && topOneShotsArray.count != 0 && topDoujinArray.count != 0 {
            switch RankMagna(rawValue: collectionView.tag) {
                case .topRankedMagna:
                 topElement = topRankedArray[indexPath.row]
                 cell?.MagnaName.text = topElement.title
                    if let url = URL(string: topElement.imageUrl!){
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if let data = data {
                                DispatchQueue.main.async {
                                    cell?.MagnaImage.image = UIImage(data: data)
                                }
                            }
                        }.resume()
                    }
                case .topOneShotsMagna:
                topElement = topOneShotsArray[indexPath.row]
                 cell?.MagnaName.text = topElement.title
                    if let url = URL(string: topElement.imageUrl!){
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if let data = data {
                                DispatchQueue.main.async {
                                    cell?.MagnaImage.image = UIImage(data: data)
                                }
                            }
                        }.resume()
                    }
                 case .topDoujinMagna:
                 topElement = topDoujinArray[indexPath.row]
                 cell?.MagnaName.text = topElement.title
                    if let url = URL(string: topElement.imageUrl!){
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if let data = data {
                                DispatchQueue.main.async {
                                    cell?.MagnaImage.image = UIImage(data: data)
                                }
                            }
                        }.resume()
                    }
                case .none:
                 cell?.MagnaName.text = "There is no Magna"
            }
        }
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topAnimeItem:AnimeData
        switch RankMagna(rawValue: collectionView.tag) {
        case .topRankedMagna:
            topAnimeItem = topRankedArray[indexPath.row]
            if let url = URL(string: topAnimeItem.url!){
                 let safari = SFSafariViewController(url: url)
                 present(safari, animated: true, completion: nil)
            }
        case .topOneShotsMagna:
            topAnimeItem = topOneShotsArray[indexPath.row]
            if let url = URL(string: topAnimeItem.url!){
                 let safari = SFSafariViewController(url: url)
                 present(safari, animated: true, completion: nil)
            }
        case .topDoujinMagna:
            topAnimeItem = topDoujinArray[indexPath.row]
            if let url = URL(string: topAnimeItem.url!){
                 let safari = SFSafariViewController(url: url)
                 present(safari, animated: true, completion: nil)
            }
        default :
            if let url = URL(string: "https://myanimelist.net/"){
                 let safari = SFSafariViewController(url: url)
                 present(safari, animated: true, completion: nil)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
