//
//  PersonResultViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//

import UIKit
import Network
class PersonResultViewController: UIViewController{
     
    var selection = 0
    
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask:URLSessionDataTask?
    var collectionMonitor = NWPathMonitor()
    var voiceActorsObject: ShowPersonResult?
    var everyActingRoles = [ActingRoles]()

    
    @IBOutlet weak var acgAppreanceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acgAppreanceCollectionView.delegate = self
        acgAppreanceCollectionView.dataSource = self
        
        collectionMonitor.pathUpdateHandler = {path in
            
            if path.status == .satisfied{
                self.getVoiceActorDAta()
            }else if path.status == .unsatisfied{
                self.ifNoConnection()
            }
        }
        
        collectionMonitor.start(queue: DispatchQueue.global())
    }
    
    func getVoiceActorDAta(){
        
        downloadTask = clientSide.getPersonData(genre: "person", identity: selection, completion: { (acgActorInfo, error) in
              if let actorInfo = acgActorInfo{
                   self.voiceActorsObject = actorInfo
             }
            
            DispatchQueue.main.async {
                self.acgAppreanceCollectionView.reloadData()
                self.renderScreen()
            }
        })

    }
    
    
    func renderScreen(){
           
        for roles in voiceActorsObject?.actingRoles ?? []{
            everyActingRoles.append(roles)
        }

    }
    
    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension PersonResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        everyActingRoles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400.0, height: 110.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = acgAppreanceCollectionView.dequeueReusableCell(withReuseIdentifier: "acgAppreanceCell", for: indexPath) as? supportingCollectionViewCell
        
        let actingRoles:ActingRoles
        
        actingRoles = everyActingRoles[indexPath.row]
        cell?.animeNameLabel.text = actingRoles.anime?.name
        cell?.characterName.text = actingRoles.character?.name
        
        if let url = URL(string: (actingRoles.anime?.imageUrl)!){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                DispatchQueue.main.async {
                    cell?.animeImage.image = UIImage(data: data)
                   }
                }
            }).resume()
        }
        
        if let url = URL(string: (actingRoles.character?.imageUrl)!){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error)  in
                if let data = data {
                DispatchQueue.main.async {
                    cell?.animeImage.image = UIImage(data: data)
                   }
                }
            }).resume()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
          let headerView = acgAppreanceCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? VoiceActorsHeaderView
        
        if let url = URL(string: voiceActorsObject?.imageUrl! ?? "https://upload.wikimedia.org/wikipedia/commons/1/12/White_background.png" ){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        headerView?.actorImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        headerView?.actorName.text = voiceActorsObject?.name
        headerView?.actorDescription.text = voiceActorsObject?.about
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel) 
    }
}

class VoiceActorsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var actorDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
    
