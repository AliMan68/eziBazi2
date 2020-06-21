//
//  GetSingleGame.swift
//  EasyBazi
//
//  Created by Ali Arabgary on 6/20/20.
//  Copyright © 2020 AliArabgary. All rights reserved.

import UIKit

class GetSinglrGame {
    static func getGame(for id:String,completion:@escaping (Game,Int,String)-> Void){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let saleUrl:String = "\(delegate.url)/api/game-for-shop/\(id)"
        var request = URLRequest(url: URL(string:saleUrl)!)
        request.httpMethod = "GET"
        var game:Game!
        var status:Int!
        var message:String!
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
                let allData = try  JSONDecoder().decode(GameObject.self, from: data)
                game = allData.data
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    
                    completion(game,status,message)
                    
                }
                
            }
            catch{
                print(" Sale for Get single game api don't work body!!!")
            }
        }
        task.resume()
    }
    
}

