//
//  CharacterResultViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//


import Network
import UIKit

class CharacterResultViewController: UIViewController{
    
    var selection = 0


    var characterInfo:ShowCharacterResult?
    var charcterApperance=[AnimeCharacter]()
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var animeAppreances: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask:URLSessionDataTask?
    var collectionMonitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animeAppreances.delegate = self
        animeAppreances.dataSource = self
       
        collectionMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                self.getCharacter()
            }else if path.status == .unsatisfied{
                self.ifNoConnection()
            }
        }
        collectionMonitor.start(queue: DispatchQueue.global())
        
    }
    
    func getCharacter(){
        downloadTask = clientSide.getCharacterData(genre: "character", identity: selection, completion: { (characterInfoData, error) in
            
            if let characterInfoData = characterInfoData {
                 self.characterInfo = characterInfoData
            
                print("AAA")
                DispatchQueue.main.async {
                    self.renderScreen()
                    self.animeAppreances.reloadData()
                }
            }
        })
    }
    
    func renderScreen(){
        characterName.text = characterInfo?.name
        descriptionLabel.text = characterInfo?.about
        
        if let url = URL(string: characterInfo!.imageUrl){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.characterImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        for animeAppearances in characterInfo?.animeography ?? [] {
            charcterApperance.append(animeAppearances)
        }
    }
    
    
    
    
    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension CharacterResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130.0, height: 195)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return charcterApperance.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = animeAppreances.dequeueReusableCell(withReuseIdentifier: "characterApperanceCollectionCell", for: indexPath) as? characterApperanceCollectionViewCell
        let number = indexPath.row
        var eachAnimeAppreance:AnimeCharacter
        eachAnimeAppreance = charcterApperance[number]
        
        cell?.acgName.text = eachAnimeAppreance.name
        
        if let url = URL(string: eachAnimeAppreance.imageUrl){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell?.acgImage.image = UIImage(data: data)
                    }
                }
            }.resume()
         }
   
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
    
    
    /*

     class CharacterDetailsViewController: UIViewController {

         var characterDetailsArray: CharacterDetails?
         var voiceActorsArray: [Voice_actors] = []
         var animeAppearancesArray: [Animeography] = []
         
         override func viewDidLoad() {
             super.viewDidLoad()
             getCharacterDetails()
         }

         
         func getCharacterDetails() {
             networkManager.getCharacterDetails(id: selection) { [weak self] (characterDetails, error) in
                 if let error = error {
                     print(error)
                 }
                 
                 if let characterDetails = characterDetails {
                     self?.characterDetailsArray = characterDetails
                 }
                 
                 self?.screenWillShow = true
                 
                 self?.setUpData()
                 
                 DispatchQueue.main.async {
                     self?.setLabels()
                     self?.animeAppearancesCollectionView.reloadData()
                     self?.charactersCollectionView.reloadData()
                     self?.activityIndicator.stopAnimating()
                     self?.mainView.isHidden = false
                 }
             }
         }
         
         func setLabels() {
             self.navigationItem.title = characterDetailsArray?.name
             japaneseNameLabel.text = characterDetailsArray?.name_kanji
             mainImageView.layer.cornerRadius = 10
             mainImageView.loadImageUsingCacheWithUrlString(urlString: characterDetailsArray?.image_url ?? "")
             descriptionLabel.text = characterDetailsArray?.about
         }
         

     }


     extension CharacterDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
         

         
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             
             if collectionView == animeAppearancesCollectionView {
                 let animeAppearancesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "animeAppearancesCell", for: indexPath) as! CharacterDetailsCollectionViewCell
                 
                 let animeAppearances: Animeography
                 
                 animeAppearances = animeAppearancesArray[indexPath.row]
                 animeAppearancesCell.voiceActorImageView.loadImageUsingCacheWithUrlString(urlString: animeAppearances.image_url ?? "")
                 animeAppearancesCell.nameLabel.text = animeAppearances.name
                 
                 return animeAppearancesCell
             }
         }
         

     }
    */


