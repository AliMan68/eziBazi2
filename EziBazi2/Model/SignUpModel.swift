//
//  SignUpModel.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/16/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit

class SignUP {
    
   static var token:String = ""
    static var status:Int = 0
    static func signUpMethod(_ fullName:String,email:String,password:String,completion:@escaping (String,Int)-> Void){
        var url:URL!
        url = URL(string: "http://192.168.10.83/izi-bazi.ud/api/register")
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "full_name=\(fullName)&email=\(email)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            //            let responseString = String(data: data, encoding: .utf8)
            //            print("responseString = \(String(describing: responseString))")
            do{
                let dictionary = try  JSONSerialization.jsonObject(with: data) as! [String:Any]
                for (key,value) in dictionary {
                    if (key == "data"){
                        if let info:[ String : Any ] = value as? [ String : Any ]{
                                for (key,value) in info {
                                    if key == "token"{
                                        token = String(describing:value)
                                    }
                                }
                        }

                    }else if key == "status"{
                        status = value as! Int
                    }
                }
                DispatchQueue.main.async {
                    let catchToken = token
                    let catchStatus = status
                    completion(catchToken,catchStatus)
                    token = ""
                    status = 0
                }
            }catch{
                
            }
        }
        task.resume()
    }
    
    
}
