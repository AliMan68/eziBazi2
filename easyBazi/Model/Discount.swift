//
//  Discount.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/9/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

struct DiscountObject:Decodable{
    var status:Int
    var message:String
    var data:DiscountData?
}

struct DiscountData:Decodable {
    var id:Int
    var code:String
    var percent:Int
}


class Discount {
    static func getInfo(for discountCode:String,token:String,completion:@escaping (Int,String,Int?)-> Void){
        let baseUrl = (UIApplication.shared.delegate as! AppDelegate).url
        let url = "\(baseUrl)/api/discount-check"
        var status:Int!
        var message:String!
        var code:Int?
        var request = URLRequest(url: URL(string:url )!)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        let requestBody = "code=\(discountCode)"
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
                let allData = try  JSONDecoder().decode(DiscountObject.self, from: data)
                status = allData.status
                message = allData.message
                code = allData.data?.percent
                DispatchQueue.main.async {
                    completion(status,message,code)
                }
            }
            catch{
                print(" discount api don't work body!!!")
            }
        }
        task.resume()
    }
}
