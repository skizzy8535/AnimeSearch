//
//  SearchViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/4.
//

import UIKit
import Network
import CoreData

@available(iOS 13.0, *)
class SearchViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{

    var searchController:UISearchController!
    
    @IBOutlet weak var searchView: UITableView!
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    
    
    var type:String? = "anime"
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var fetchSearchTask :URLSessionDataTask?
    let connectionMonitor = NWPathMonitor()
    let activityIndicator = UIActivityIndicatorView()
    
    var animeResults = [SearchResults]()
    var mangaResults = [SearchResults]()
    var personResults = [SearchResults]()
    var characterResults = [SearchResults]()

    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selection = 0
    var saveSearchedAnime :[FavoriteAnime]?
    var saveSearchedMagna :[FavoriteManga]?
    var saveSearchedPerson :[FavoritePerson]?
    var saveSearchedCharacter :[FavoriteCharacter]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        searchView.dataSource = self
        searchView.isHidden = true
        searchControllerHelper()
        
        connectionMonitor.pathUpdateHandler = { path in
        if path.status == .unsatisfied {
           DispatchQueue.main.async {
               self.ifNoConnection()
           }
        }
     }
            
        connectionMonitor.start(queue: DispatchQueue.global())
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupActivityIndicator()
    }
    
    var bannedSearchWords = ["Loli", "Lolita", "Lolicon", "Roricon", "Shotacon",
                             "Shota", "Yaoi", "Ecchi", "Hentai", "loli", "lolita",
                             "lolicon", "roricon","shotacon", "shota", "yaoi",
                             "ecchi", "hentai"]
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    func searchControllerHelper(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Anime, Manga, Character, or Person"
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .black
        searchController.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if bannedSearchWords.contains(searchBar.text!){
            let alert = UIAlertController(title: "You can't search for this type of content.", message: "The content you typed is banned on the app store and can not be shown.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "All right", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
            self.activityIndicator.startAnimating()
            getSearchedAnime()
            getSearchedManga()
            getSearchedPerson()
            getSearchedCharacter()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           animeResults.removeAll()
           mangaResults.removeAll()
           personResults.removeAll()
           characterResults.removeAll()
    }
    
    func getSearchedAnime(){
        type = "anime"
        fetchSearchTask = clientSide.getSearchResult(type: type!, keyword:  searchController.searchBar.text, completion: {[self]  (searchTopAnime, error) in
            self.fetchSearchTask = nil
                       
            if let searchedResult = searchTopAnime?.results{
                self.animeResults.append(contentsOf: searchedResult)
                DispatchQueue.main.async {
                      self.searchView.reloadData()
                      self.activityIndicator.stopAnimating()
                      self.searchView.isHidden = false
                 }
            }
        })
    }
    
    func getSearchedManga(){
        type = "manga"
        fetchSearchTask = clientSide.getSearchResult(type: type!, keyword: searchController.searchBar.text, completion: { [self] (searchTopAnime, error) in
            self.fetchSearchTask = nil
     
            if let searchResult = searchTopAnime?.results{
                self.mangaResults.append(contentsOf: searchResult)
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.searchView.isHidden = false
                }
            }
        })
    }
    
    func getSearchedPerson(){
        type = "person"
        fetchSearchTask = clientSide.getSearchResult(type: type!, keyword:  searchController.searchBar.text, completion: { [self] (searchTopAnime, error) in
            self.fetchSearchTask = nil
         
            if let searchResult = searchTopAnime?.results{
                self.personResults.append(contentsOf: searchResult)
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.searchView.isHidden = false
                }
            }
        })
    }

    func getSearchedCharacter(){
        type = "character"
    fetchSearchTask = clientSide.getSearchResult(type: type!, keyword:  searchController.searchBar.text, completion: {[self] (searchTopAnime, error) in
            self.fetchSearchTask = nil
          
            if let searchResult = searchTopAnime?.results{
                self.characterResults.append(contentsOf: searchResult)
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.searchView.isHidden = false
                }
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchView.isHidden = true
            animeResults.removeAll()
            mangaResults.removeAll()
            personResults.removeAll()
            characterResults.removeAll()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment.selectedSegmentIndex {
            case 0:
              return animeResults.count
            case 1:
              return mangaResults.count
            case 2:
              return personResults.count
            case 3:
              return characterResults.count
            default:
              return animeResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as? SearchTableViewCell
        let number = indexPath.row
        var results :SearchResults
        
            if selectedSegment.selectedSegmentIndex == 0{
                results = animeResults[number]
                cell?.resultSearchName.text = results.title
                cell?.resultImage.image = UIImage(contentsOfFile:"MAL")
                
                if let url = URL(string: results.imageURL){
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if let data = data{
                            DispatchQueue.main.async {
                                cell?.resultImage.image = UIImage(data: data)
                            }
                        }
                    }).resume()
                }
                
                
            }else if selectedSegment.selectedSegmentIndex == 1{
                results = mangaResults[number]
                cell?.resultSearchName.text = results.title
                cell?.resultImage.image = UIImage(contentsOfFile:"MAL")
                
                if let url = URL(string: results.imageURL){
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if let data = data{
                            DispatchQueue.main.async {
                                cell?.resultImage.image = UIImage(data: data)
                            }
                        }
                    }).resume()
                }
            }else if selectedSegment.selectedSegmentIndex == 2{
                results = personResults[number]
                
                cell?.resultSearchName.text = results.name
                cell?.resultImage.image = UIImage(contentsOfFile:"MAL")
                
                if let url = URL(string: results.imageURL){
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if let data = data{
                            DispatchQueue.main.async {
                                cell?.resultImage.image = UIImage(data: data)
                            }
                        }
                    }).resume()
                }
            }else if selectedSegment.selectedSegmentIndex == 3{
                results = characterResults[number]
                               
                cell?.resultSearchName.text = results.name
                cell?.resultImage.image = UIImage(contentsOfFile:"MAL")
                
                
                if let url = URL(string: results.imageURL){
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if let data = data{
                            DispatchQueue.main.async {
                                cell?.resultImage.image = UIImage(data: data)
                            }
                        }
                    }).resume()
                }
            }
        
        return cell!
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var results :SearchResults
        
         if selectedSegment.selectedSegmentIndex == 0 {
        
       //      如果只有引入一次單一的 Core Data Ｍodel 可以呼叫 Core Data Ｍodel 的 init(context:)方法來操作 Managed Object
       //      let newFavoriteAnime = FavoriteAnime(context: context)
            
       //      如果Core Data Ｍodel 引入全部的畫面超過一次 , 使用 init(context:)會出現類似下列的錯誤訊息
            
       //   CoreData: warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Favorite'Anime' so +entity is unable to disambiguate.
       //  2021–01–10 09:27:50.813787+1000 [error] warning: 'FavoriteAnime' (0x600001b88160) from NSManagedObjectModel (0x600000f9f7f0) claims 'FavoriteAnime'.
       
       //  比較好的新增Managed Object 方法
       let newFavoriteAnime = NSEntityDescription.insertNewObject(forEntityName: "FavoriteAnime", into: context) as! FavoriteAnime
            
                results = animeResults[indexPath.row]
                let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
                let addToFavorite = UIAlertAction(title: "Add to Favorite Anime", style: .default) { (action) in
               
                    newFavoriteAnime.name = results.title
                    newFavoriteAnime.imageUrl = results.imageURL
                    newFavoriteAnime.identity = Float(results.identity)
                    newFavoriteAnime.isSaved = true
                    self.container.checkIfDuplicate(FavoriteAnime.self, identity: newFavoriteAnime.identity)
                    self.container.saveContext()
                    
                }
            
                let goToDetailPage = UIAlertAction(title: "See Anime Details..", style: .default) { (action) in
                    
                    self.selection = results.identity
                    self.performSegue(withIdentifier: "showAnimeSearchSegue", sender: self )
                    self.container.checkIfExists(FavoriteAnime.self, identity: newFavoriteAnime.identity)
                }
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    self.container.checkIfExists(FavoriteAnime.self, identity: newFavoriteAnime.identity)
                }
            
                optionMenu.addAction(addToFavorite)
                optionMenu.addAction(goToDetailPage)
                optionMenu.addAction(cancelAction)
                self.present(optionMenu, animated: true, completion: nil)
        
         }else if selectedSegment.selectedSegmentIndex == 1 {
            let newFavoriteMagna = NSEntityDescription.insertNewObject(forEntityName: "FavoriteManga", into: context) as! FavoriteManga
            
                results = mangaResults[indexPath.row]
            
                let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
                let addToFavorite = UIAlertAction(title: "Add to Favorite Magna", style: .default) { (action) in
                    newFavoriteMagna.name = results.title
                    newFavoriteMagna.imageUrl = results.imageURL
                    newFavoriteMagna.identity = Float(results.identity)
                    newFavoriteMagna.isSaved = true
                    self.container.checkIfDuplicate(FavoriteManga.self, identity: newFavoriteMagna.identity)
                    self.container.saveContext()
            }
            
                let goToDetailPage = UIAlertAction(title: "See Manga Details..", style: .default) { (action) in
                    self.selection = results.identity
                    self.performSegue(withIdentifier: "showMangaSearchSegue", sender: self )
                    self.container.checkIfExists(FavoriteManga.self, identity: newFavoriteMagna.identity)
            }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    self.container.checkIfExists(FavoriteManga.self, identity: newFavoriteMagna.identity)
                }
        
               optionMenu.addAction(addToFavorite)
               optionMenu.addAction(goToDetailPage)
               optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
         }else if selectedSegment.selectedSegmentIndex == 2 {
            let newFavoritePerson = NSEntityDescription.insertNewObject(forEntityName: "FavoritePerson", into: context) as! FavoritePerson
                results = personResults[indexPath.row]
                let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
                let addToFavorite = UIAlertAction(title: "Add to Favorite Person", style: .default) { (action) in
                    newFavoritePerson.name = results.name
                    newFavoritePerson.imageUrl = results.imageURL
                    newFavoritePerson.identity = Float(results.identity)
                    newFavoritePerson.isSaved = true
                    self.container.checkIfDuplicate(FavoritePerson.self, identity: newFavoritePerson.identity)
                    self.container.saveContext()
        }
                let goToDetailPage = UIAlertAction(title: "See Person Details..", style: .default) { (action) in
                    self.selection = results.identity
                    self.performSegue(withIdentifier: "showPersonSearchSegue", sender: self )
                    self.container.checkIfExists(FavoritePerson.self, identity: newFavoritePerson.identity)
            }
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
                    self.container.checkIfExists(FavoritePerson.self, identity: newFavoritePerson.identity)
                }
            
                optionMenu.addAction(addToFavorite)
                optionMenu.addAction(goToDetailPage)
                optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
         }else if selectedSegment.selectedSegmentIndex == 3{
            let newFavoriteCharacter = NSEntityDescription.insertNewObject(forEntityName: "FavoriteCharacter", into: context) as! FavoriteCharacter
                results = characterResults[indexPath.row]
                let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
                let addToFavorite = UIAlertAction(title: "Add to Favorite Character", style: .default) { (action) in
                    newFavoriteCharacter.name = results.name
                    newFavoriteCharacter.imageUrl = results.imageURL
                    newFavoriteCharacter.identity = Float(results.identity)
                    newFavoriteCharacter.isSaved = true
                    self.container.checkIfDuplicate(FavoriteCharacter.self, identity: newFavoriteCharacter.identity)
                    self.container.saveContext()

          }
                let goToDetailPage = UIAlertAction(title: "See Character Details..", style: .default) { (action) in
                    self.selection = results.identity
                    print(self.selection)
                    self.performSegue(withIdentifier: "showCharacterSearchSegue", sender: self )
                    self.container.checkIfExists(FavoriteCharacter.self, identity: newFavoriteCharacter.identity)
            }
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
                    self.container.checkIfExists(FavoriteCharacter.self, identity: newFavoriteCharacter.identity)
                }
            
               optionMenu.addAction(addToFavorite)
               optionMenu.addAction(goToDetailPage)
               optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
         }
     
    }

    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
            DispatchQueue.main.async {
                self.searchView.reloadData()
            }
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != nil {
            if selectedSegment.selectedSegmentIndex == 0{
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }else if selectedSegment.selectedSegmentIndex == 1{
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }else if selectedSegment.selectedSegmentIndex == 2{
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }else if selectedSegment.selectedSegmentIndex == 3{
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }else if searchController.searchBar.text?.count == 0{
            searchView.isHidden = true
            searchControllerHelper()
        }
    }
    
    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnimeSearchSegue"{
            let animeDetailsVC = segue.destination as? AnimeResultViewController
            animeDetailsVC?.selection = selection
        }else if segue.identifier == "showMangaSearchSegue"{
            let mangaDetailsVC = segue.destination as? MangaResultViewController
            mangaDetailsVC?.selection = selection
        }else if segue.identifier == "showPersonSearchSegue"{
            let personDetailsVC = segue.destination as? PersonResultViewController
            personDetailsVC?.selection = selection
        }else if segue.identifier == "showCharacterSearchSegue"{
            let characterDetailsVC = segue.destination as? CharacterResultViewController
            characterDetailsVC?.selection = selection
            
        }
    }

}


