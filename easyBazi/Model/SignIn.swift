//
//  SignIn.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/20/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//


import UIKit

struct SigninObject:Decodable {
    var status:Int
    var message:String
    var data:CompleteSignUpInData?
}

class SignIn {
   
     static func signInMethod(_ mobileNumber:String,password:String,completion:@escaping (Int,String,CompleteSignUpInData?)-> Void){
        var url:URL!
        
        var message:String = ""
        var status:Int = 0
        var signUpInInfo:CompleteSignUpInData?
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/login")
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "mobile=\(mobileNumber)&password=\(password)"
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
            //            let responseString = String(data: data, encoding: .utf8)
            //            print("responseString = \(String(describing: responseString))")
            do{
                let allData = try JSONDecoder().decode(SigninObject.self, from: data)
                status = allData.status
                message = allData.message
                signUpInInfo = allData.data
                
                DispatchQueue.main.async {
                    completion(status,message,signUpInInfo)
                  
                }
            }catch{
                print("Error in signin")
            }
        }
        task.resume()
    }
    
    
}
