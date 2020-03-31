//
//  SaleData.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/4/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class GetDataForRentCV {
    static func getData(_ Url:String,completion:@escaping (Array<Game>,Int)-> Void){
        var request = URLRequest(url: URL(string:Url )!)
        request.httpMethod = "GET"
        var status:Int!
        var gameArray = [Game]()
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
                let allData = try  JSONDecoder().decode(GameObject.self, from: data)
                gameArray = allData.data.data
                status = allData.status
                DispatchQueue.main.async {
                    let container = gameArray
                    completion(container,status)
                    gameArray.removeAll()
                }
            }
            catch{
                print(" Rent api don't work body!!!")
            }
        }
        task.resume()
    }
    
}

