//
//  SaleData.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/4/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class GetDataForSaleVC {
    static func getData(_ Url:String,completion:@escaping (Array<Game>,String,Int,String?)-> Void){
        var gameArray = [Game]()
        var nextPageUrl:String!
        var status:Int!
        var message:String?
        var request = URLRequest(url: URL(string:Url )!)
        request.httpMethod = "GET"
        print(Url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {               // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do{
                let allData = try  JSONDecoder().decode(GameObject.self, from: data)
                gameArray = allData.data.data
                nextPageUrl = allData.data.next_page_url
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    let url:String!
                    if nextPageUrl != nil{
                        url = nextPageUrl
                    }else{
                        url = ""
                    }
completion(gameArray,url!,status,message)
                    nextPageUrl = ""
                }
                
            }
            catch{
                print(" Sale for VC api don't work body!!!")
            }
        }
        task.resume()
    }
    
}


