//
//  SaleData.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/4/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
struct RelaedGameObject: Decodable{
    var status : Int
    var message:String
    var data:[Game]?
    
}
class RelatedGames {
    static func get(_ Url:String?,completion:@escaping (Array<Game>,Int)-> Void){
        guard let url = Url else{
            return
        }
        var request = URLRequest(url: URL(string:url )!)
        var gameArray = [Game]()
        var status:Int!
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { 	          // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
               
                let allData = try  JSONDecoder().decode(RelaedGameObject.self, from: data)
                status = allData.status
                gameArray = allData.data ?? []
                DispatchQueue.main.async{
                    let container = gameArray
                    completion(container,status)
                    gameArray.removeAll()
                }
            }
            catch{
                print("Related Api Don't Work!!!")
            }
        }
        task.resume()
    }
    
}
