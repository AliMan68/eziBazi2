//
//  File.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/23/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
struct UserFinanceObject:Decodable {
    var status:Int
    var message:String
    var data:UserAccount
}
struct UserAccount:Decodable {
    var user_balance:Int
}
class UserFinance {
    static func get(_ token:String,completion:@escaping (Int,String,Int)-> Void){
        var status:Int!
        var message:String!
        var accountBalance:Int!
        var url:URL!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/user-finance")
        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.setValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
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
                let allData = try  JSONDecoder().decode(UserFinanceObject.self, from: data)
                status = allData.status
                message = allData.message
                accountBalance = allData.data.user_balance
                DispatchQueue.main.async {
                    completion(status,message,accountBalance)
                }
            }catch{
                print("Error In getting finance-Info model")
            }
        }
        task.resume()
    }
    
    
}
