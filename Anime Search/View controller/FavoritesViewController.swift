//
//  FavoritesViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/11.
//

import UIKit
import CoreData


class FavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var selectedSegement: UISegmentedControl!
    @IBOutlet weak var favoritesTable: UITableView!
    @IBOutlet weak var totalText: UILabel!
    
    var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var allSavedAnime = [FavoriteAnime]()
    var allSavedManga = [FavoriteManga]()
    var allSavedPerson = [FavoritePerson]()
    var allSavedCharacter = [FavoriteCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllSavedAnime()
        fetchAllSavedMagna()
        fetchAllSavedPerson()
        fetchAllSavedCharacter()
        favoritesTable.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegement.selectedSegmentIndex{
        case 0:
            return allSavedAnime.count
        case 1:
            return allSavedManga.count
        case 2:
            return allSavedPerson.count
        case 3:
            return allSavedCharacter.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.favoritesTable.frame.width, height: 25))
        
        switch selectedSegement.selectedSegmentIndex{
            case 0:
                totalText.text = "Total: \(allSavedAnime.count)"
            case 1:
                totalText.text = "Total: \(allSavedManga.count)"
            case 2:
                totalText.text = "Total: \(allSavedPerson.count)"
            case 3:
                totalText.text = "Total: \(allSavedCharacter.count)"
            default:
                totalText.text = "Total: \(allSavedAnime.count)"
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTable.dequeueReusableCell(withIdentifier: "favoriteTableCell", for: indexPath) as? FavoriteTableViewCell
        let number = indexPath.row
        let animeResult : FavoriteAnime?
        let magnaResult : FavoriteManga?
        let personResult : FavoritePerson?
        let characterResult : FavoriteCharacter?
        switch selectedSegement.selectedSegmentIndex {
        case 0:
            animeResult = allSavedAnime[number]
            cell?.itemName.text = animeResult?.name
            cell?.itemImage.image = UIImage(named: "MAL")

            if let url = URL(string: animeResult!.imageUrl!){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell?.itemImage.image = UIImage(data: data)
                        }
                    }
                }).resume()
            }
        case 1:
            magnaResult = allSavedManga[indexPath.row]
            cell?.itemName.text = magnaResult?.name
            cell?.itemImage.image = UIImage(named: "MAL")
            
            if let url = URL(string: magnaResult!.imageUrl!){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell?.itemImage.image = UIImage(data: data)
                        }
                    }
                }).resume()
            }
            
        case 2:
            personResult = allSavedPerson[indexPath.row]
            cell?.itemName.text = personResult?.name
            cell?.itemImage.image = UIImage(named: "MAL")
            
            if let url = URL(string: personResult!.imageUrl!){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell?.itemImage.image = UIImage(data: data)
                        }
                    }
                }).resume()
            }
            
        case 3:
            characterResult = allSavedCharacter[indexPath.row]
            cell?.itemName.text = characterResult?.name
            cell?.itemImage.image = UIImage(named: "MAL")
            
            if let url = URL(string: characterResult!.imageUrl!){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell?.itemImage.image = UIImage(data: data)
                        }
                    }
                }).resume()
            }
        default:
            animeResult = allSavedAnime[number]
            cell?.itemName.text = animeResult?.name
            cell?.itemImage.image = UIImage(named: "MAL")
            if let url = URL(string: animeResult!.imageUrl!){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell?.itemImage.image = UIImage(data: data)
                        }
                    }
                }).resume()
            }
        }
        
        
        
        return cell!
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        DispatchQueue.main.async {
            self.favoritesTable.reloadData()
        }
    }
    
   
    func fetchAllSavedAnime(){
        let context = container.viewContext
        let entityName = String(describing: FavoriteAnime.self)
        let request = NSFetchRequest<FavoriteAnime>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let array = try context.fetch(request)
            allSavedAnime = array as [FavoriteAnime]
        } catch  {
            print("error")
        }
        
        
        
    }

    
    func fetchAllSavedMagna(){
        let context = container.viewContext
        let entityName = String(describing: FavoriteManga.self)
        let request = NSFetchRequest<FavoriteManga>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let array = try context.fetch(request)
            allSavedManga = array as [FavoriteManga]
        } catch  {
            print("error")
        }
    }
    
    func fetchAllSavedPerson(){
        let context = container.viewContext
        let entityName = String(describing: FavoritePerson.self)
        let request = NSFetchRequest<FavoritePerson>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let array = try context.fetch(request)
            allSavedPerson = array as [FavoritePerson]

        } catch  {
            print("error")
        }
    }
    
    func fetchAllSavedCharacter(){
        let context = container.viewContext
        let entityName = String(describing: FavoriteCharacter.self)
        let request = NSFetchRequest<FavoriteCharacter>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let array = try context.fetch(request)
            allSavedCharacter = array as [FavoriteCharacter]

        } catch  {
            print("error")
        }
    }
  
    
     
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if selectedSegement.selectedSegmentIndex == 0{
            let anime = allSavedAnime[indexPath.row]
            self.container.delete(FavoriteAnime.self, identity: anime.identity)
            allSavedAnime.remove(at:indexPath.row)
            favoritesTable.deleteRows(at: [indexPath], with: .fade)
            self.container.saveContext()
        }else if selectedSegement.selectedSegmentIndex == 1{
            let manga = allSavedManga[indexPath.row]
            self.container.delete(FavoriteManga.self, identity: manga.identity)
            allSavedManga.remove(at:indexPath.row)
            favoritesTable.deleteRows(at: [indexPath], with: .fade)
            self.container.saveContext()
        }else if selectedSegement.selectedSegmentIndex == 2{
            let person = allSavedPerson[indexPath.row]
            self.container.delete(FavoritePerson.self, identity: person.identity)
            allSavedPerson.remove(at:indexPath.row)
            favoritesTable.deleteRows(at: [indexPath], with: .fade)
            self.container.saveContext()
        }else if selectedSegement.selectedSegmentIndex == 3{
            let character = allSavedCharacter[indexPath.row]
            self.container.delete(FavoriteCharacter.self, identity: character.identity)
            allSavedCharacter.remove(at:indexPath.row)
            favoritesTable.deleteRows(at: [indexPath], with: .fade)
            self.container.saveContext()
        }
     }
   
}

   
   
