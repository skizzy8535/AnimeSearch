//
//  MangaResultViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//

import UIKit
import Network
class MangaResultViewController: UIViewController {
    
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask:URLSessionDataTask?
    var selection = 0
    var mangaResult :ShowACGInformation?
    
    @IBOutlet weak var mangaImage: UIImageView!
    @IBOutlet weak var mangaScore: UILabel!
    @IBOutlet weak var mangaRank: UILabel!
    @IBOutlet weak var mangaChapters: UILabel!
    @IBOutlet weak var mangaName: UILabel!
    @IBOutlet weak var allGenre: UILabel!
    @IBOutlet weak var introContext: UILabel!
    
   
    let collectionMonitor = NWPathMonitor()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.getAllData()
            } else if path.status == .unsatisfied {
               DispatchQueue.main.async {
                   self.ifNoConnection()
               }
            }
         }
        collectionMonitor.start(queue: DispatchQueue.global())
        // Do any additional setup after loading the view.
    }
    
     func getAllData(){
              downloadTask = clientSide.getACGData(genre: "manga", identity: selection, completion: { (acgInfo, error) in
                   if let acgResult = acgInfo {
                      self.mangaResult = acgResult
                     DispatchQueue.main.async {
                         self.renderAnimeData()
                     }
          }})
     }
     
     func renderAnimeData(){

         if let url = URL(string: mangaResult!.imageUrl){
             URLSession.shared.dataTask(with: url) { (data, response, error) in
                 DispatchQueue.main.async {
                     self.mangaImage.image = UIImage(data: data!)
                 }
             }.resume()
         }
            mangaScore.text = String(mangaResult?.score ?? 0)
            mangaRank.text = String(mangaResult?.rank ?? 0)
            mangaChapters.text = String(mangaResult?.chapters ?? 0)
            mangaName.text =  String(mangaResult?.title ?? "")
           introContext.text = String(mangaResult?.synopsis ?? "")
           for genres in mangaResult?.genres ?? []{
             allGenre.text! += "\(genres.name)     "
          }
     }
     
     
     
    
    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }


}
