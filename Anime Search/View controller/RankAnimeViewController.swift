//
//  RankAnimeViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/1.
//

import UIKit
import Network

enum AnimeSection: Int {
    case topRankedAnime
    case topAiringAnime
    case topUpcomingAnime
    case topMovieAnime
    static var numberOfSections: Int { return 4 }
}

class RankAnimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var AnimeRankTable: UITableView!
    
    let connectionMonitor = NWPathMonitor()
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask:URLSessionDataTask?

    var query = "top"
    var page = 1
    var type = "anime"
    var subtype:String? = "favorite"
    
    var topRankedArray = [AnimeData]()
    var topAiringArray = [AnimeData]()
    var topUpcomingArray = [AnimeData]()
    var topMovieArray = [AnimeData]()
    var selection = 0
    
    let loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AnimeRankTable.dataSource = self
        self.AnimeRankTable.delegate = self
        loadingIndicator.color = .systemRed
        loadingIndicator.startAnimating()
    
        connectionMonitor.pathUpdateHandler = { path in
             if path.status == .satisfied {
                self.getTopRank()
                self.getTopAiring()
                self.getTopUpcoming()
                self.getTopMovie()
             } else if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    self.AnimeRankTable.isHidden = true
                    self.loadingIndicator.stopAnimating()
                    self.ifNoConnection()
                }
             }
          }
        connectionMonitor.start(queue: DispatchQueue.global())
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
    
    func getTopRank(){
        subtype = "favorite"
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: { [self](topAnime, error) in
            self.downloadTask = nil
            
            if let rankItems = topAnime?.top{
                self.topRankedArray.append(contentsOf:rankItems)
                DispatchQueue.main.async {
                    self.AnimeRankTable.reloadData()
                }
            }
        })
    }
    
    func getTopAiring(){
        subtype = "airing"
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: { [self] (topAnime, error) in
            self.downloadTask = nil
            
            if let airItems = topAnime?.top{
                self.topAiringArray.append(contentsOf:airItems)
                DispatchQueue.main.async {
                    self.AnimeRankTable.reloadData()
                }
            }
            
        })
    }
    
    func getTopUpcoming(){
        subtype = "upcoming"
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: { [self] (topAnime, error) in
            self.downloadTask = nil
            
            if let upcomingItems = topAnime?.top{
                self.topUpcomingArray.append(contentsOf: upcomingItems)
                DispatchQueue.main.async {
                    self.AnimeRankTable.reloadData()
                }
            }
            
        })
    }
    
    func getTopMovie(){
        subtype = "movie"
        downloadTask = clientSide.getAnimeList(query: query, type: type, page: page, subtype: subtype!, completion: { [self] (topAnime, error) in
            self.downloadTask = nil
            
            if let upcomingItems = topAnime?.top{
                self.topMovieArray.append(contentsOf: upcomingItems)
                DispatchQueue.main.async {
                    self.AnimeRankTable.reloadData()
                    self.loadingIndicator.stopAnimating()
                    self.AnimeRankTable.isHidden = false
                }
            }
            
        })
    }
    
    
    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
        
    
    func numberOfSections(in tableView: UITableView) -> Int {
        AnimeSection.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnimeRankTable.dequeueReusableCell(withIdentifier: "animeCell", for: indexPath) as? AnimeRankCell
        return cell!
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 13, width: 250, height: 20)
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        
        switch AnimeSection(rawValue: section){
            case .topRankedAnime :
                label.text = "Top Ranked Anime"
                label.textColor = .black
            case .topAiringAnime :
                label.text = "Top Airing Anime"
                label.textColor = .black
            case .topUpcomingAnime :
                label.text = "Top Upcoming Anime"
                label.textColor = .black
            case .topMovieAnime :
                label.text = "Top Movie Anime"
                label.textColor = .black
            default:
                label.text = "No Anime Data"
    
    }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let animeRankCell = cell as? AnimeRankCell else { return }
        animeRankCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
  }

extension RankAnimeViewController:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch AnimeSection(rawValue: section) {
        case .topRankedAnime:
          return topRankedArray.count
        case .topAiringAnime:
            return topAiringArray.count
        case .topUpcomingAnime:
            return topUpcomingArray.count
        case .topMovieAnime:
            return topMovieArray.count
        case .none:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animeCollectionViewCell", for: indexPath) as? AnimeCollectionViewCell
        var topElement: AnimeData
     
        if topRankedArray.count != 0 && topAiringArray.count != 0 && topUpcomingArray.count != 0 && topMovieArray.count != 0 {
        switch AnimeSection(rawValue: collectionView.tag) {
            case .topRankedAnime:
                topElement = topRankedArray[indexPath.row]
                cell?.animeName.text = topElement.title
              
                if let url = URL(string: topElement.imageUrl!){
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        DispatchQueue.main.async {
                            cell?.animePictures.image = UIImage(data: data!)
                        }
                    }.resume()
                }
          case .topAiringAnime:
                topElement = topAiringArray[indexPath.row]
            cell?.animeName.text = topElement.title
         
            if let url = URL(string: topElement.imageUrl!){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.animePictures.image = UIImage(data: data!)
                    }
                }.resume()
            }
          case .topUpcomingAnime:
            topElement = topUpcomingArray[indexPath.row]
            cell?.animeName.text = topElement.title
         
            if let url = URL(string: topElement.imageUrl!){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.animePictures.image = UIImage(data: data!)
                    }
                }.resume()
            }
         case .topMovieAnime:
            topElement = topMovieArray[indexPath.row]
            cell?.animeName.text = topElement.title
         
            if let url = URL(string: topElement.imageUrl!){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.animePictures.image = UIImage(data: data!)
                    }
                }.resume()
            }
            case .none:
                cell?.animeName.text = "No Anime Available"
            }
        }
        return cell!
        
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let topAnimeItem:AnimeData
        
    switch AnimeSection(rawValue: collectionView.tag) {
        case .topRankedAnime:
            topAnimeItem = topRankedArray[indexPath.row]
            selection = topAnimeItem.identity
            self.performSegue(withIdentifier: "showAnimeRankSegue", sender: self)
        case .topAiringAnime:
            topAnimeItem = topAiringArray[indexPath.row]
            selection = topAnimeItem.identity
            self.performSegue(withIdentifier: "showAnimeRankSegue", sender: self)
        case .topUpcomingAnime:
            topAnimeItem = topUpcomingArray[indexPath.row]
            selection = topAnimeItem.identity
            self.performSegue(withIdentifier: "showAnimeRankSegue", sender: self)
        case .topMovieAnime :
            topAnimeItem = topMovieArray[indexPath.row]
            selection = topAnimeItem.identity
            self.performSegue(withIdentifier: "showAnimeRankSegue", sender: self)
        default :
            topAnimeItem = topRankedArray[indexPath.row]
            selection = topAnimeItem.identity
            self.performSegue(withIdentifier: "showAnimeRankSegue", sender: self)
        }
      }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 270)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showAnimeRankSegue"{
            let animeResultVC = segue.destination as? AnimeResultViewController
            animeResultVC?.selection = selection
        }
    }
}
