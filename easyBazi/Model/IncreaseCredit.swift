//
//  IncreaseCredit.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/18/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

struct IncreaseCreditStruct:Decodable {
    var status:Int!
    var message:String?
    var data:String?
}

class IncreaseCredit {
    static func pay(token:String,amount:String,completion:@escaping (Int,String,String)-> Void){
        let url = "\((UIApplication.shared.delegate as! AppDelegate).url)/api/increase-credit"
        var status:Int!
        var message:String!
        var link:String!
        var request = URLRequest(url: URL(string:url )!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "Post"
        let requestBody = "amount=\(amount)"
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
                let allData = try  JSONDecoder().decode(IncreaseCreditStruct.self, from: data)
                status = allData.status
                message = allData.message
                link = allData.data
                DispatchQueue.main.async {
                    completion(status,message,link)
                }
            }
            catch{
                print(" Saving Address api don't work body!!!")
            }
        }
        task.resume()
    }
    
}

