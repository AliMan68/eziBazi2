//
//  BuyActivity.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/12/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit

struct BuyedGameObject :Decodable{
    var status:Int
    var message:String
    var data:[BuyedGameData]
}
struct BuyedGameData:Decodable {
    var is_sent: Int
    var is_delivered: Int
    var is_finish: Int
    var game_for_shop:Game
    var created_at:String
}

class BuyActivity{
    static func Get(token:String,completion:@escaping (Int,[BuyedGameData])->Void){
        var status:Int!
        var games:[BuyedGameData] = []
        let  delegate = (UIApplication.shared.delegate as! AppDelegate).url
        let url = URL(string:"\(delegate)/api/user-game-for-shop-requests")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer  \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                print("Error = '\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try  JSONDecoder().decode(BuyedGameObject.self, from: data)
                games = allData.data
                status = allData.status
                DispatchQueue.main.async {
                    completion(status,games)
                }
            }catch{
                print("Error In Buyed Games Api")
            }
        }
        task.resume()
    }
}

