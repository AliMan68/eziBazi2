//
//  MessageSeen.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/8/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//


import Foundation
import UIKit

struct IsMesageSeenObject:Decodable{
    var message:String
    var status:Int
    var data:String?
}

struct MessageObject:Decodable{
    var message:String
    var status:Int
    var data:MessageData
}
struct MessageData:Decodable{
    var data:[Messagee]
}
struct Messagee:Decodable{
    var text:String
    var is_user_sent:Int
    var is_seen:Int
    var created_at:String
}

class Message{
    static func Get(token:String,completion: @escaping ([Messagee],Int)->Void){
        var messages:[Messagee] = []
        var status:Int!
        let  delegate = (UIApplication.shared.delegate as! AppDelegate).url
        let url = URL(string:"\(delegate)/api/ticket")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer  \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                print("Error = '\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try  JSONDecoder().decode(MessageObject.self, from: data)
                status = allData.status
                messages = allData.data.data
                DispatchQueue.main.async {
                    completion(messages,status)
                }
            }catch{
                print("Error In Getting Messages")
            }
            
            
        }
        task.resume()
        
        
    }
    
    
    
    
    static func Seen(token:String,completion:@escaping(Int)->Void){
        var status:Int!
        let  delegate = (UIApplication.shared.delegate as! AppDelegate).url
        let url = URL(string:"\(delegate)/api/ticket-user-seen")
        // new message  = new-tickets-count
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer  \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,error == nil else{
                print("Error = '\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try  JSONDecoder().decode(IsMesageSeenObject.self, from: data)
                status = allData.status
                
                DispatchQueue.main.async {
                    completion(status)
                }
            }catch{
                print("Error In User Seen model")
            }
        }
        task.resume()
    }
    
    
}
