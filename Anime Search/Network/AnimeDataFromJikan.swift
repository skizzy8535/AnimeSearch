//
//  AnimeDataFromJikan.swift
//  Anime Search
//
//  Created by 林祐辰 on 2020/12/30.
//

import Foundation

protocol GetDatasFromJikan {
    func getAnimeList(query:String,type:String,page:Int?,subtype:String?,completion:@escaping (TopAnime?,Error?)->Void)->URLSessionDataTask
    func getSearchResult(type:String,keyword:String?,completion: @escaping (SearchData?,Error?)->Void)->URLSessionDataTask
}


class AnimeDataFromJikan:GetDatasFromJikan{
    var originURL:URL = URL(string:"https://api.jikan.moe/v3/")!
    static let shared = AnimeDataFromJikan()

    
    // Ex:  https://api.jikan.moe/v3/search/anime?q=one%20piece
    func getSearchResult(type:String,keyword:String?,completion: @escaping (SearchData?,Error?)->Void)->URLSessionDataTask{
        var urlCompoments = "search\(type)?q="
        
        if let keyword = keyword{
            urlCompoments = "search/\(type)?q=\(keyword)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        }
        
        let getSearchedURL = URL(string: urlCompoments, relativeTo: originURL)!
        var request = URLRequest(url: getSearchedURL)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) {[self](data, response, error) in
            if let data = data ,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil {
                do {
                    let model = try JSONDecoder().decode(SearchData.self, from: data)
                    showSearchedResult(searchModel: model,completion: completion)
                } catch{
                    showSearchedResult(error: error, completion: completion)
                }
            }
        }
        task.resume()
        return task
    }
    
    // https://api.jikan.moe/v3/season/2019/winter
    
    // Ex: https://api.jikan.moe/v3/top/anime/1/favorite
    func getAnimeList(query:String,type: String, page: Int?, subtype: String?,completion: @escaping (TopAnime?, Error?) -> Void) -> URLSessionDataTask {
        var urlComponets = "\(query)/\(type)"
        
        if let page = page,
           let subtype = subtype{
            urlComponets = "\(query)/\(type)/\(page)/\(subtype)"
        }else{
            urlComponets = "\(query)/\(type)/1/favorite"
        }
       
        
        let getAnimeURL = URL(string: urlComponets, relativeTo: originURL)!
        var getAnimeRequest = URLRequest(url: getAnimeURL)
        getAnimeRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: getAnimeRequest) { [self] (data, response, error) in
            if let data = data ,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil{
                  do{
                      let animeData = try JSONDecoder().decode(TopAnime.self, from: data)
                      showAnimeResult(animeModel: animeData,completion: completion)
                  }catch{
                      showAnimeResult(error: error,completion: completion)
                    }
                }
        }
        task.resume()
        return task
    }
    
    func showAnimeResult<Type>(animeModel:Type? = nil , error:Error? = nil , completion:@escaping (Type?,Error?)->Void){
        DispatchQueue.main.async {
            completion(animeModel,error)
        }
    }
    
    
    func showSearchedResult<Type>(searchModel:Type? = nil , error:Error? = nil , completion :@escaping (Type?,Error?) ->Void){
        DispatchQueue.main.async {
            completion(searchModel,error)
        }
    }
}

