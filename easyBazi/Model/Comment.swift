//
//  SendComment.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/22/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit

class Comment{
    static var userName:String = ""
    static var message:String = ""
    static var status:Int = 0

    static var gameArray = [Game]()
    static func send(_ gameInfoId:Int,text:String,token:String,completion:@escaping (String, Int)-> Void){
        var url:URL!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        gameArray.removeAll()
            url = URL(string: "\(delegate)/api/comment")
        var request = URLRequest(url: url)
       // request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer  \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let postString = "commentable_type=GameInfo&text=\(text)&commentable_id=\(gameInfoId)"
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
                let dictionary = try  JSONSerialization.jsonObject(with: data) as! [String:Any]
                for (key,value) in dictionary {
                    if (key == "data"){
                        if let info:[ String : Any ] = value as? [ String : Any ]{
                            for (key,value) in info {
                                 if key == "user"{
                                    if let info:[ String : Any ] = value as? [ String : Any ]{
                                        for (key,value) in info {
                                            if key == "full_name"{
                                                userName = String(describing:value)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        
                    }else if key == "status"{
                        status = value as! Int
                    }else if key == "message"{
                        message = String(describing:value)
                    }
                }
                DispatchQueue.main.async {
                    let stu = status
                    let mssg = message
                    completion(mssg,stu)
                    status = 0
                    message = ""
                }
            }catch{
                
            }
        }
        task.resume()
    }
}

