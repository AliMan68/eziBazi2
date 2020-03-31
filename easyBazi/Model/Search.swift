//
//  Search.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/6/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//
import UIKit
struct searchObject:Decodable{
    var status:Int
    var message:String
    var data:[Game]?
}


struct SearchPostObject: Decodable{
    var status : Int
    var message:String
    var data:[Post]?
    
}

class Search{
    static func serachMethod(_ textSearched:String,urlType:String,completion:@escaping (Array<Game>, String,Int)-> Void){
        var url:URL!
        var gameArray:[Game]?
        
        var status:Int!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        var message :String!
        if urlType == "shop" || urlType == "rent"{
            url = URL(string: "\(delegate)/api/game-for-\(urlType)-search")
        }else{
             url = URL(string: "\(delegate)/api/\(urlType)-search")
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "city_id=14&text=\(textSearched)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                DispatchQueue.main.async {
                    completion([],"",-1)
                }
                // check for http errors
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                DispatchQueue.main.async {
                    completion([],"",-1)
                }// check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
            
                            let allData = try  JSONDecoder().decode(searchObject.self, from: data)
                                    message = allData.message
                                    status = allData.status
                                    gameArray = allData.data
                                    DispatchQueue.main.sync {
                                        completion(gameArray ?? [],message,status)
                                    }
            
            }catch{
                print("Error in serching")
            }
        }
        task.resume()
    }
    
    static func forPosts(_ textSearched:String,completion:@escaping (Array<Post>, String,Int)-> Void){
            var url:URL!
            var status:Int!
            var posts:[Post]?
            let delegate = (UIApplication.shared.delegate as! AppDelegate).url
            var message :String!
            url = URL(string: "\(delegate)/api/post-search")
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let postString = "text=\(textSearched)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
    //            let responseString = String(data: data, encoding: .utf8)
    //            print("responseString = \(String(describing: responseString))")
                do{
                
                                let allData = try  JSONDecoder().decode(SearchPostObject.self, from: data)
                                message = allData.message
                                status = allData.status
                                posts = allData.data
                                DispatchQueue.main.sync {
                                    completion(posts ?? [],message,status)
                                        }
                
                }catch{
                    print("Error in Post serching")
                }
            }
            task.resume()
        }
}
