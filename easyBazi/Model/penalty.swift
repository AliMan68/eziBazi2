//
//  penalty.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/9/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//
import UIKit

struct RentPenaltyObject:Decodable{
    var status:Int
    var message:String
    var data:Int?
}

class RentPenalty {
    static func get(for gameId:Int,token:String,completion:@escaping (Int,String,Int)-> Void){
        let baseUrl = (UIApplication.shared.delegate as! AppDelegate).url
        let url = "\(baseUrl)/api/rent-penalty"
        var status:Int!
        var message:String!
        var penaltyAmount:Int!
        var request = URLRequest(url: URL(string:url )!)
        request.httpMethod = "Post"
        let requestBody = "game_id=\(gameId)"
        request.httpBody = requestBody.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                let allData = try  JSONDecoder().decode(RentPenaltyObject.self, from: data)
                status = allData.status
                message = allData.message
                
                if allData.data == nil {
                penaltyAmount = 0
                }else{
                    penaltyAmount = allData.data
                }
                DispatchQueue.main.async {
                    completion(status,message,penaltyAmount)
                }
            }
            catch{
                print(" Penalty api don't work body!!!")
            }
        }
        task.resume()
    }
}
