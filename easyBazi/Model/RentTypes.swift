//
//  RentTypes.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/8/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import UIKit

class RentTypes {
    static func get(_ Url:String,completion:@escaping (Array<rentType>,Int,String)-> Void){
        var status:Int!
        var message:String!
        var types:[rentType] = [rentType]()
        var request = URLRequest(url: URL(string:Url )!)
        request.httpMethod = "GET"
        
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
                let allData = try  JSONDecoder().decode(rentTypes.self, from: data)       
                types = allData.data
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    completion(types,status,message)
                }
            }
            catch{
                print(" Rent Types api don't work body!!!")
            }
        }
        task.resume()
    }
    
}

