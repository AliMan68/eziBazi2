//
//  commentCell.swift
//  EziBazi2
//
//  Created by Ali Arabgary on 6/4/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit

class commentCell: baseCell {
    
    
    var comment:comment! {
        didSet{
            guard let commentObject = comment else {
                return
            }
            writer.text =  " : " + commentObject.user.full_name
            date.text = dateConvertor(from: commentObject.created_at)
            content.text = commentObject.text
        }
    }
    
    let writer: UILabel = {
       var label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.font = UIFont(name: "IRANSans", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ali aseman 68"
        label.textAlignment = .right
        return label
    }()
    let date: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.6)
        label.font = UIFont(name: "IRANSans", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "۱۳۹۷/۱۳/۲۹"
        return label
    }()
    let content: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.text = "این فقط یک متن تستی برای آزمایش بخش کامنت ها میباشد و دارای ارزش دیگری نیست. نوجه توجه"
        return label
    }()
    let dividerView:UIView = {
      var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.alpha = 0.6
        view.layer.cornerRadius = 2
        return view
    }()
    fileprivate func dateConvertor(from string:String )->String{
        let date = String(string)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateInGrogrian = dateFormatter.date(from: date)
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.persian)
        let components = calendar?.components(NSCalendar.Unit(rawValue: UInt.max), from: dateInGrogrian!)
        let year =  convertToPersian(inputStr: String(describing: components!.year!))
        let month =  convertToPersian(inputStr: String(describing: components!.month!))
        let day =  convertToPersian(inputStr: String(describing: components!.day!))
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateInPersian = "\(year)/\(month)/\(day)"
        return dateInPersian
    }
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    override func setupViews() {
        super.setupViews()
        backgroundColor = .backgroundThem
        addSubview(writer)
        writer.topAnchor.constraint(equalTo: topAnchor, constant: +8).isActive = true
        writer.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(date)
        date.topAnchor.constraint(equalTo: topAnchor, constant: +8).isActive = true
        date.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        
        addSubview(content)
        content.topAnchor.constraint(equalTo: writer.bottomAnchor , constant: 8).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        addSubview(dividerView)
        dividerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        dividerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
    }
    
}
