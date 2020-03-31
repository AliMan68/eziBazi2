//
//  GameShopWithEpay.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/10/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import UIKit


struct ShopGameStruct:Decodable {
    var status:Int!
    var message:String?
    var data:String?
}

class ShopGameEpay {
    static func pay(_ token:String,gameId:Int,addressId:Int,discountCode:String,completion:@escaping (String,Int,String)-> Void){
        let baseUrl = (UIApplication.shared.delegate as! AppDelegate).url
        let url = "\(baseUrl)/api/shop-game"
        var status:Int!
        var message:String!
        var payLink:String!
        var request = URLRequest(url: URL(string:url )!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "Post"
        let requestBody = "game_id=\(gameId)&address_id=\(addressId)&discount_code\(discountCode)"
        request.httpBody = requestBody.data(using: .utf8)
        
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
                let allData = try  JSONDecoder().decode(ShopGameStruct.self, from: data)
                
                payLink = allData.data
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    completion(payLink,status,message)
                }
            }
            catch{
                print(" Shop game with ePay api don't work body!!!")
            }
        }
        task.resume()
    }
}

