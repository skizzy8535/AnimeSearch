//
//  AnimeDataFromJikan.swift
//  Anime Search
//
//  Created by 林祐辰 on 2020/12/30.
//

import Foundation
import UIKit

protocol GetDatasFromJikan {
    func getAnimeList(query:String,type:String,page:Int?,subtype:String?,completion:@escaping (TopAnime?,Error?)->Void)->URLSessionDataTask
    func getSearchResult(type:String,keyword:String?,completion: @escaping (SearchData?,Error?)->Void)->URLSessionDataTask
    func getACGData(genre:String,identity:Int,completion:@escaping(ShowACGInformation?,Error?)->Void)->URLSessionDataTask
    func getPersonData(genre:String,identity:Int,completion:@escaping(ShowPersonResult?,Error?)->Void)->URLSessionDataTask
    func getCharacterData(genre:String,identity:Int,completion:@escaping(ShowCharacterResult?,Error?)->Void)->URLSessionDataTask
    func getScheduleData(genre:String,weekDay:String,completion:@escaping(ShowSchedule?,Error?)->Void)->URLSessionDataTask
}

class AnimeDataFromJikan:GetDatasFromJikan{
    var originURL:URL = URL(string:"https://api.jikan.moe/v3/")!
    static let shared = AnimeDataFromJikan()

    func showSearchedResult<Type>(searchModel:Type? = nil , error:Error? = nil , completion :@escaping (Type?,Error?) ->Void){
        DispatchQueue.main.async {
            completion(searchModel,error)
        }
    }
    
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
    
    func showAnimeResult<Type>(animeModel:Type? = nil , error:Error? = nil ,completion:@escaping (Type?,Error?)->Void){
        DispatchQueue.main.async {
            completion(animeModel,error)
        }
    }
    
    
    
    
    
    
    // Ex:  https://api.jikan.moe/v3/anime/5114
    
    func getACGData(genre:String,identity:Int,completion:@escaping(ShowACGInformation?,Error?)->Void)->URLSessionDataTask{
         let urlComponments = "\(genre)/\(identity)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        let dataURL = URL(string: urlComponments, relativeTo: originURL)
        var fetchRequest = URLRequest(url: dataURL!)
        fetchRequest.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: fetchRequest) { [self] (data, response, error) in
            if let data = data ,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil{
                do {
                    let acgData = try JSONDecoder().decode(ShowACGInformation.self, from: data)
                    showDataResult(dataModel: acgData, completion: completion)
                }catch{
                    showDataResult(error: error, completion: completion)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    
    func showDataResult<Type>(dataModel:Type? = nil, error :Error? = nil,completion:@escaping (Type?,Error?)->Void){
        DispatchQueue.main.async {
            completion(dataModel,error)
        }
    }
    
    
    func getPersonData(genre:String,identity:Int,completion:@escaping(ShowPersonResult?,Error?)->Void)->URLSessionDataTask{
         let urlComponments = "\(genre)/\(identity)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        let dataURL = URL(string: urlComponments, relativeTo: originURL)
        var fetchRequest = URLRequest(url: dataURL!)
        fetchRequest.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: fetchRequest) { [self] (data, response, error) in
            if let data = data ,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil{
                do {
                    let acgData = try JSONDecoder().decode(ShowPersonResult.self, from: data)
                    showPersonResult(personModel: acgData, completion: completion)
                }catch{
                    showPersonResult(error: error, completion: completion)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    
    func showPersonResult<Type>(personModel:Type? = nil, error :Error? = nil,completion:@escaping (Type?,Error?)->Void){
        DispatchQueue.main.async {
            completion(personModel,error)
        }
    }
    
    
    func getCharacterData(genre:String,identity:Int,completion:@escaping(ShowCharacterResult?,Error?)->Void)->URLSessionDataTask{
         let urlComponments = "\(genre)/\(identity)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        let dataURL = URL(string: urlComponments, relativeTo: originURL)

        var fetchRequest = URLRequest(url: dataURL!)
        fetchRequest.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: fetchRequest) { [self] (data, response, error) in
            if let data = data ,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil{
                do {
                    let scheduleData = try JSONDecoder().decode(ShowCharacterResult.self, from: data)
                    showCharacterResult(characterModel: scheduleData, completion: completion)
                }catch{
                    showCharacterResult(error: error, completion: completion)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    
    func showCharacterResult<Type>(characterModel:Type? = nil, error :Error? = nil,completion:@escaping (Type?,Error?)->Void){
        DispatchQueue.main.async {
            completion(characterModel,error)
        }
    }
    
    
    func getScheduleData(genre:String,weekDay:String,completion:@escaping(ShowSchedule?,Error?)->Void)->URLSessionDataTask{
         let urlComponments = "\(genre)/\(weekDay)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        
        let dataURL = URL(string: urlComponments, relativeTo: originURL)
        var fetchRequest = URLRequest(url: dataURL!)
        fetchRequest.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: fetchRequest) { [self] (data, response, error) in
            if let data = data ,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil{
                do {
                    let scheduleData = try JSONDecoder().decode(ShowSchedule.self, from: data)
                    showScheduleResult(scheduleModel: scheduleData, completion: completion)
                }catch{
                    showScheduleResult(error: error, completion: completion)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    
    func showScheduleResult<Type>(scheduleModel:Type? = nil, error :Error? = nil,completion:@escaping (Type?,Error?)->Void){
        DispatchQueue.main.async {
            completion(scheduleModel,error)
        }
    }
    

    
}

