//
//  SendMessage.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/1/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
struct ticketObject:Decodable {
    var status:Int
    var message:String
    var data:ticketData
}
struct ticketData:Decodable {
    var is_user_sent:Int
    var text: String
    var is_seen: Int
    var created_at:String

}

class Ticket:NSObject{
    static func send(_ text:String,token:String,complition:@escaping (Int,String,String)->Void){
        var status:Int!
        var url:URL!
        var message:String!
        var createAt:String!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/ticket")
        var request = URLRequest(url: url)
        // request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer  \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let postString = "is_user_sent=1&text=\(text)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            do{
                let allData = try  JSONDecoder().decode(ticketObject.self, from: data)
                status = allData.status
                message = allData.message
                createAt = allData.data.created_at
                DispatchQueue.main.async {
                    complition(status,message,createAt)
                }
            
            }catch{
                print("Error in ticket message model")
            }
        }
        task.resume()
    }

    
    
}
