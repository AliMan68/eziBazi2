//
//  NewMessage.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/8/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
struct NewMessageOnject:Decodable{
    var status:Int
    var message:String
    var data:Int
}
class NewMessage{
    
    static func Received(token:String,completion:@escaping (Int,Int,String)->Void){
        var newTicketCount:Int!
        var status:Int!
        var message:String = ""
        let  delegate = (UIApplication.shared.delegate as! AppDelegate).url
        let url = URL(string:"\(delegate)/api/new-tickets-count")
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
                let allData = try JSONDecoder().decode(NewMessageOnject.self, from: data)
                newTicketCount = allData.data
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    completion(newTicketCount,status,message)
                }
            }catch{
                print("Error in new message count model")
            }
        }
        task.resume()
    }
}
