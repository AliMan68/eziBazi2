//
//  GetActivity.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/11/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit

struct RentedGameObject :Decodable{
    var message:String
    var status:Int
    var data:[RentedGameData]
}
struct RentedGameData:Decodable {
    var id: Int
    var is_sent: Int
    var is_returned: Int
    var game_price: Int
    var is_finish: Int
    var rent_type:rentType
    var rent_price:Int
    var game_for_rent:Game
    var finished_at:String
    var created_at:String
//    var created_at:String?
}
struct rentType:Decodable {
    var id:Int
    var day_count:Int
    var price_percent:Int
}

class RentActivity{
    static func Get(token:String,completion:@escaping (Int,[RentedGameData])->Void){
        var games:[RentedGameData] = []
        var status:Int!
        let  delegate = (UIApplication.shared.delegate as! AppDelegate).url
        let url = URL(string:"\(delegate)/api/user-game-for-rent-requests")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                print("Error = '\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(-1,[])
                }// check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try  JSONDecoder().decode(RentedGameObject.self, from: data)
                games = allData.data
                status = allData.status
                DispatchQueue.main.async {
                    completion(status,games)
                }
            }catch{
                print("Error In getting rented games model")
            }
        }
        task.resume()
    }
}
