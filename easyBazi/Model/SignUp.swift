//
//  SignUp.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/17/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//




import Foundation
import UIKit

struct SignupObject:Decodable{
    var status:Int
    var message:String
    var data:SignupData?
}
struct SignupData:Decodable {
    var verification_code:VerificationCodeVerify
}       
struct VerificationCodeVerify:Decodable {
    var id:Int
    var mobile:String
    var code:String
    var token:String?
    var is_verified:Int
}


//signup completion structs
struct CompleteSignupObject:Decodable {
    var status:Int
    var message:String
    var data:CompleteSignUpInData?
}
struct CompleteSignUpInData:Decodable {
    var token:String?
    var user:User
    
}
struct User:Decodable {
    var full_name:String
    var email:String
    var mobile:String
    var national_code:String?
    var invite_code:String
    
}


class SignUP {
    static func complete( fullName:String,email:String,nationalCode:String,mobileNumber:String,password:String,token:String,completion:@escaping (Int,String,CompleteSignUpInData?)-> Void){
        
        var message:String = ""
        var dataInfo:CompleteSignUpInData?
        var status:Int = 0
        var url:URL!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/register")
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "full_name=\(fullName)&email=\(email)&national_code=\(nationalCode)&mobile=\(mobileNumber)&password=\(password)&token=\(token)"
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
                let allData = try JSONDecoder().decode(CompleteSignupObject.self, from: data)
                status = allData.status
                message = allData.message
                dataInfo = allData.data
                DispatchQueue.main.async {
                    completion(status,message,dataInfo)
                }
            }catch{
                print("Error in signup complete model")
            }
        }
        task.resume()
    }
    
    
    
    
}
