//
//  GetDataForGameRentDetail.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/13/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit


struct PostObject: Decodable{
    var status : Int!
    var message:String?
    var data:PostDataObject
    
}
struct PostDataObject:Decodable{
    var current_page:Int?
    var data:[Post]
}
struct Post:Decodable {
    var id:Int
    var title:String
    var content:String
    var photos:[photo]
    var created_at:String
    var url:String?
}
class GetDataForPostCV {
    static func getData(completion:@escaping (Array<Post>,Int)-> Void){
        let delegate = (UIApplication.shared.delegate as! AppDelegate)
        let urlString = "\(delegate.url)/api/post"
        var request = URLRequest(url: URL(string:urlString)!)
        request.httpMethod = "GET"
        var status:Int!
        var gameArray = [Post]()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")        
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {               // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try  JSONDecoder().decode(PostObject.self, from: data)
                gameArray = allData.data.data
                status = allData.status
                DispatchQueue.main.async {
                    let container = gameArray
                    completion(container,status)
                    gameArray.removeAll()
                }
                
            }
            catch{
                print(" Post api don't work body!!!")
            }
        }
        task.resume()
    }
    
}
