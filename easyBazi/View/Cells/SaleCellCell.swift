//
//  SaleCellCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 5/19/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

class SaleCellCell:baseCell{
    
    var game:Game!{
           didSet{
            if game.game_info.photos.count != 0{
                   let url = URL(string:game.game_info.photos[0].url)
                   gameImage.sd_setImage(with: url, placeholderImage:UIImage(named:"GOW"),completed: nil)
               }else{
                   gameImage.image = UIImage(named:"notFound")
               }
            gameName.text = game.game_info.name?.uppercased()
               gamePrice.text = convertToPersian(inputStr: String(describing: Int(game.price).formattedWithSeparator)) + " تومان"
        }
       }
    
    
    
    let gameImage:UIImageView = {
        let image = UIImage(named: "GOW")
        var iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
//        iv.layer.radius = 10
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
   
    
    let stack:UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let gameName:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "San Francisco Display", size: 14)
        label.textAlignment = .left
        label.textColor = .white
//        label.text = "RED DEAD REDEMPTION2"
        return label
    }()
    
    let gamePrice:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 13)
        label.textAlignment = .left
        label.textColor = .easyBaziTheme
//        label.text = "۲۰۰,۰۰۰ تومان"
        return label
    }()
    
    let gameOff:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "-۱۰ ٪"
        return label
    }()
    
    let container:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 1
//        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        setupImage()
        setupContainer()
        setupNamePrice()
        
    }
    fileprivate func setupImage(){
        addSubview(gameImage)
        gameImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gameImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        gameImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        gameImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    fileprivate func setupContainer(){
        addSubview(container)
        container.heightAnchor.constraint(equalTo: gameImage.heightAnchor ,multiplier: 0.5).isActive = true
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(white: 0, alpha: 0.85).cgColor,UIColor.clear]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.height * 0.5)
        
        gradientLayer.locations = [NSNumber(value:0.3),NSNumber(value:1)]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        container.layer.addSublayer(gradientLayer)
    }
    
    fileprivate func setupNamePrice(){
        container.addSubview(gameName)
        container.addSubview(gamePrice)
        
        gamePrice.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        gamePrice.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        gamePrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        gameName.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        gameName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        gameName.bottomAnchor.constraint(equalTo: gamePrice.topAnchor, constant: -4).isActive = true
              
    }
    
    //helper func's
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        return str
    }
    
}
