//
//  States.swift
//  EziBazi2
//
//  Created by AliArabgary on 2/19/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit
import Foundation
class States {
    
    static func get(url:String,complition:@escaping (Array<State>,Int)->Void ){
        var status:Int = 0
        var states:[State] = []
        guard let url =  URL(string: url)else{ return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
         
            guard let data = data,error == nil else{
                print("error=\(String(describing: error))")
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print("Status code should be 200 but it is \(httpStatus.statusCode)")
                print("the response is : \(String(describing: response))")
            }
            do{
                let States = try JSONDecoder().decode(StateObject.self, from: data)
//                print(States.data[5].name)
                states = States.data
                status = States.status
                DispatchQueue.main.async {
                    complition(states,status)
                }
            }catch {
                print(" States api don't work!!!")
            }
            }.resume()
        
    }
    
    static func getCities(url:String,complition:@escaping (Array<City>,Int)->Void ){
        var status:Int = 0
        var cities:[City] = []
        guard let url =  URL(string: url)else{ return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print("Status code should be 200 but it is \(httpStatus.statusCode)")
                print("the response is : \(String(describing: response))")
            }
            do{
                let Cities = try JSONDecoder().decode(CityObject.self, from: data)
                cities = Cities.data
                status = Cities.status
                DispatchQueue.main.async {
                    complition(cities,status)
                }
            }catch {
                print(" Cities api don't work!!!")
            }
            }.resume()
        
    }
    
    
    
}

