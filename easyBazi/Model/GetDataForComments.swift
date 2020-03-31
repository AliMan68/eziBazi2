//
//  GetDataForComments.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/20/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit


struct commentObject:Decodable{
    var status:Int
    var message:String
    var data:commentData?
    
    
}
struct commentData:Decodable {
    var data:[comment]?
    var next_page_url:String?
}
struct comment:Decodable {
    var text:String
    var created_at:String
    var user:user
}
struct user:Decodable {
    var full_name:String
}

class GetComments{
    
    
    static func comments(_ id :Int,token:String,urlString:String,pageInit:Bool,completion:@escaping (commentData?,Int)-> Void){
        var url:URL!
        var status:Int!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        var comments:commentData?
        if pageInit {
            url = URL(string: urlString)
        }else{
            url = URL(string: "\(delegate)/api/game-info-comments/\(id)")
        }
       
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                DispatchQueue.main.async {
                    completion(nil,-1)
                }
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                DispatchQueue.main.async {
                                  completion(nil,-1)
                              }// check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            //            let responseString = String(data: data, encoding: .utf8)
            //            print("responseString = \(String(describing: responseString))")
            do{
                let allData = try  JSONDecoder().decode(commentObject.self, from: data)
                comments = allData.data
                status = allData.status
                DispatchQueue.main.async {
                    completion(comments ?? nil,status)
                }
            }catch{
                print("Error In comments model")
            }
        }
        task.resume()
    }
}
