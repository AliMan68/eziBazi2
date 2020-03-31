//
//  Address.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/10/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//



import UIKit

class Address {
    static func set(_ Url:String,token:String,cityId:Int,stateId:Int,postCode:Int,phoneNumber:Int,content:String,completion:@escaping (address,Int,String)-> Void){
        var status:Int!
        var message:String!
        var address:address!
        var request = URLRequest(url: URL(string:Url )!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "Post"
        let requestBody = "state_id=\(stateId)&city_id=\(cityId)&home_phone_number=\(phoneNumber)&postcode=\(postCode)&content=\(content)&latitude=0&longitude=0"
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
                let allData = try  JSONDecoder().decode(addressObject.self, from: data)
                
                address = allData.data
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    completion(address,status,message)
                }
            }
            catch{
                print(" Saving Address api don't work body!!!")
            }
        }
        task.resume()
    }
    
}

