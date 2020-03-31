//
//  GetDataForSlider.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/13/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
struct SliderObject: Decodable{
    var status : Int!
    var message:String?
    var data:[SliderDataObject]
    
}
struct SliderDataObject:Decodable{
    var id:Int?
    var content:String
    var on_click:String
    var title:String
    var photos:[photo]
}

class GetDataForSlider {
    static func getData(_ Url:String,completion:@escaping (Array<SliderDataObject>,Int)-> Void){
        var request = URLRequest(url: URL(string:Url )!)
        request.httpMethod = "GET"
        var gameArray = [SliderDataObject]()
        var status:Int!
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
                let allData = try  JSONDecoder().decode(SliderObject.self, from: data)
                gameArray = allData.data
                status = allData.status
                DispatchQueue.main.async {
                    let container = gameArray
                    completion(container,status)
                    gameArray.removeAll()
                }
                
            }
            catch{
                print(" Slider api don't work body!!!")
            }
        }
        task.resume()
    }
    
}
