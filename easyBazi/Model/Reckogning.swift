//
//  Reckogning.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/7/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//
import UIKit
		
struct ReckogningObject:Decodable{
    var status:Int
    var message:String
}


class Reckogning {
    static func request(accountOwner:String,cardNumber:String,accountNumber:String,shbaNumber:String,vToken:String,mobileNumber:String,token:String,completion:@escaping (Int,String)-> Void){
        print(accountOwner)
        print(cardNumber)
        print(accountNumber)
        print(shbaNumber)
        print(token)
        var message:String = ""
        var status:Int = 0
        var url:URL!
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        url = URL(string: "\(delegate)/api/settlement-request")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let postString = "bank_account_owner_name=\(accountOwner)&bank_card_number=\(cardNumber)&bank_account_number=\(accountNumber)&bank_shba_number=\(shbaNumber)&token=\(vToken)&mobile=\(mobileNumber)"
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
            do{
                let allData = try JSONDecoder().decode(ReckogningObject.self, from: data)
                status = allData.status
                message = allData.message
                DispatchQueue.main.async {
                    completion(status,message)
                }
            }catch{
                print("Error in reckogning complete model")
            }
        }
        task.resume()
    }
    
}
