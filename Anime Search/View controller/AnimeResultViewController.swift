//
//  AnimeResultViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/22.
//

import UIKit
import WebKit
import Network

class AnimeResultViewController: UIViewController {

    
    var clientSide:GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask:URLSessionDataTask?
    var collectionMonitor = NWPathMonitor()
    
    var selection = 0
    var animeResult :ShowACGInformation?
    let loadingIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var animeImage: UIImageView!
    @IBOutlet weak var animeScore: UILabel!
    @IBOutlet weak var animeRank: UILabel!
    @IBOutlet weak var episodesNumber: UILabel!
    @IBOutlet weak var animeName: UILabel!
    @IBOutlet weak var allGenre: UILabel!
    @IBOutlet weak var introContext: UILabel!
    @IBOutlet weak var trailerVideoView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionMonitor.pathUpdateHandler = {path in
            if path.status == .satisfied{
                self.getAllData()
            }else if path.status == .unsatisfied {
                self.ifNoConnection()
            }
        }
        collectionMonitor.start(queue: DispatchQueue.global())
     
    }
    

    
    func getAllData(){
        downloadTask = clientSide.getACGData(genre: "anime", identity: selection, completion: { (acgInfo, error) in
                  if let acgResult = acgInfo {
                     self.animeResult = acgResult
                
                    DispatchQueue.main.async {
                        self.renderAnimeData()
                    }
         }})
    }
    
    func renderAnimeData(){

        if let url = URL(string: animeResult!.imageUrl){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    self.animeImage.image = UIImage(data: data!)
                }
            }.resume()
        }
          animeScore.text = String(animeResult?.score ?? 0)
          animeRank.text = String(animeResult?.rank ?? 0)
          episodesNumber.text = String(animeResult?.episodes ?? 0)
          animeName.text =  String(animeResult?.title ?? "")
          introContext.text = String(animeResult?.synopsis ?? "")
          for genres in animeResult?.genres ?? []{
            allGenre.text! += "\(genres.name)     "
         }
           loadVideo(url: animeResult?.trailerUrl ?? "")
    }
    
    

    func loadVideo(url: String) {
        if let youtubeURL = URL(string: url){
            trailerVideoView.load(URLRequest(url: youtubeURL))
        }
    }

    
    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
