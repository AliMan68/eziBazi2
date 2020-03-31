//
//  GetVerificationCode.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 2/29/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import UIKit

struct VerificationCodeObject :Decodable{
    var status:Int
    var message:String
}

class VerificationCode {
    static func sendForSignup(_ mobileNumber:String,completion:@escaping (Int,String)-> Void){
        var message:String = ""
        var status:Int = 0
        var url:URL!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/verification/code-request/register")
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
//        print("mobile number = \(String(describing: mobileNumber))")
        let postString = "mobile=\(mobileNumber)"
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
                let allData = try JSONDecoder().decode(VerificationCodeObject.self, from: data)
                message = allData.message
                status = allData.status
                DispatchQueue.main.async {
                    completion(status,message)
                }
            }catch{
                print("Error in sending verification code model")
            }
        }
        task.resume()
    }
    
    
    static func sendForResetPassword(_ mobileNumber:String,completion:@escaping (Int,String)-> Void){
            var message:String = ""
            var status:Int = 0
            var url:URL!
            let delegate = (UIApplication.shared.delegate as! AppDelegate).url
            url = URL(string: "\(delegate)/api/verification/code-request/reset-password")
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
    //        print("mobile number = \(String(describing: mobileNumber))")
            let postString = "mobile=\(mobileNumber)"
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
                    let allData = try JSONDecoder().decode(VerificationCodeObject.self, from: data)
                    message = allData.message
                    status = allData.status
                    DispatchQueue.main.async {
                        completion(status,message)
                    }
                }catch{
                    print("Error in sending verification code model")
                }
            }
            task.resume()
        }
    
    static func sendForReckogning(_ token:String,completion:@escaping (Int,String)-> Void){
            var message:String = ""
            var status:Int = 0
            var url:URL!
            let delegate = (UIApplication.shared.delegate as! AppDelegate).url
            url = URL(string: "\(delegate)/api/verification/code-request/settlement")
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
    //        print("mobile number = \(String(describing: mobileNumber))")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                    let allData = try JSONDecoder().decode(VerificationCodeObject.self, from: data)
                    message = allData.message
                    status = allData.status
                    DispatchQueue.main.async {
                        completion(status,message)
                    }
                }catch{
                    print("Error in sending verification code model")
                }
            }
            task.resume()
        }
    static func codeVerify(mobileNumber:String,verificationCode:String,completion:@escaping (Int,String,String?)-> Void){
           var url:URL!
           var message:String = ""
           var token:String?
           var status:Int = 0
           let delegate = (UIApplication.shared.delegate as! AppDelegate).url
           url = URL(string: "\(delegate)/api/verification/code-verify")
           var request = URLRequest(url: url)
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           request.setValue("application/json", forHTTPHeaderField: "Accept")
           request.httpMethod = "POST"
           let postString = "mobile=\(mobileNumber)&code=\(verificationCode)"
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
                   let allData = try JSONDecoder().decode(SignupObject.self, from: data)
                   status = allData.status
                   message = allData.message
                   token = (allData.data?.verification_code.token)
                   
                   DispatchQueue.main.async {
                       completion(status,message,token)
                   }
               }catch{
                   print("Error in code verify model")
               }
           }
           task.resume()
       }
    
}

