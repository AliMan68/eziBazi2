//
//  ResetPassword.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/4/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import Foundation
import UIKit


struct resetPassword:Decodable {
    var status:Int
    var message:String
}
class ResetPassword {
    static func setNewPassword(password:String,token:String,mobileNumber:String,completion:@escaping (Int,String)-> Void){
        var message:String!
        var status:Int!
        var url:URL!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/reset-password")
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "password=\(password)&token=\(token)&mobile=\(mobileNumber)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try JSONDecoder().decode(resetPassword.self, from: data)
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    completion(status,message)
                }
            }catch{
                print("Error in reset password  model")
            }
        }
        task.resume()
    }
    
    
    
    
}
