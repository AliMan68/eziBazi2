//
//  ActivityBuyCell.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/11/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class ActivityBuyCell: baseCell {
    
    var game:BuyedGameData!{
        didSet{
            if game.game_for_shop.game_info.photos.count != 0{
                let url = URL(string:game.game_for_shop.game_info.photos[0].url)
                gameImage.sd_setImage(with: url, placeholderImage:UIImage(named:"GOW"),completed: nil)
            }else{
                gameImage.image = UIImage(named:"notFound")
            }
            
            gameName.text = game.game_for_shop.game_info.name
            gamePrice.text = convertToPersian(inputStr: String(describing: Int(game.game_for_shop.price).formattedWithSeparator)) + " تومان"
            statusImage.image = UIImage(named: "GOW")

            gameRegion.text = "Region : " + game.game_for_shop.region
            shopDate.text = " تاریخ خرید : " + (UIApplication.shared.delegate as! AppDelegate).dateConvertor(from: game.created_at)
                       
                       
          if(game.is_finish == 1) {
                         statusLabel.text = "بسته شده است."
                        statusImage.image = UIImage(named: "deliverd")
                             }
            else if(game.is_finish == 0 && game.is_delivered == 1){
                    
            statusLabel.text = "تحویل گردید."
                statusImage.image = UIImage(named: "deliverd")
                             }
            else if(game.is_finish == 0 && game.is_delivered == 0 && game.is_sent == 1){
                     statusLabel.text = "در حال ارسال..."
                     statusImage.image = UIImage(named: "delivery")
                             }
            else if(game.is_finish == 0 && game.is_delivered == 0 && game.is_sent == 0){
                     statusLabel.text = "در حال ارسال..."
                     statusImage.image = UIImage(named: "delivery")
                             }
        }
    }
    
    
    let gameImage:UIImageView = {
        let image = UIImage(named: "GOW")
        var iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    let priceContainer:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        return view
        
    }()
    let statusContainer:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        return view
        
    }()
    //    let circleContainer:UIView = {
    //        var view = UIView()
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        view.layer.cornerRadius = 5
    //        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
    //        return view
    //
    //    }()
    let circleContainer: CircleView = {
        let v = CircleView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    let stack:UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    let statusImage:UIImageView = {
        let image = UIImage(named: "logo")
        var iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    let statusLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "در حال ارسال ..."
        label.font = UIFont(name: "IRANSans", size: 12)
        label.textAlignment = .right
        return label
    }()
    
    let gameName:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "San Francisco Display", size: 16)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = "RED DEAD REDEMPTION2"
        return label
    }()
    let shopDate:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 13)
        label.textAlignment = .left
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.text = "تاریخ : ۱۳۹۷/۱۲/۱۰"
        return label
    }()
    let gameRegion:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 13)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = "REGION : 2"
        return label
    }()
    let gamePrice:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "۲۰۰.۰۰۰ تومان"
        return label
    }()
    let labelStack:UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    override func setupViews() {
        backgroundColor = UIColor.navAndTabColor
        //confguration of all view's in cell
        //        circleContainer.width = frame.size.width / 20
        configeImageView()
        configeView()
//        configeLabel()
//        configeDate()
//        configeRegion()
        configLabelStack()
        configeLeftDownView()
//        configeCircle()
        configeStack()
    }
    fileprivate func configLabelStack(){
        labelStack.addArrangedSubview(gameName)
        labelStack.addArrangedSubview(shopDate)
        labelStack.addArrangedSubview(gameRegion)
        addSubview(labelStack)
        labelStack.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        labelStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        labelStack.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 0).isActive = true
        labelStack.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -8).isActive = true
    }
    
    fileprivate func configeRegion(){
        addSubview(gameRegion)
        gameRegion.topAnchor.constraint(equalTo: shopDate.bottomAnchor, constant: 8).isActive = true
        gameRegion.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        gameRegion.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -4).isActive = true
    }
    fileprivate func configeStack(){
        statusContainer.addSubview(stack)
        stack.addArrangedSubview(statusLabel)
        stack.addArrangedSubview(statusImage)
        stack.leftAnchor.constraint(equalTo: statusContainer.leftAnchor, constant: 0).isActive = true
        stack.rightAnchor.constraint(equalTo: statusContainer.rightAnchor, constant: 10).isActive = true
        stack.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 0).isActive = true
        stack.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: 0).isActive = true
        
    }
    fileprivate func configeLeftDownView(){
        addSubview(statusContainer)
        statusContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        statusContainer.topAnchor.constraint(equalTo: gameImage.bottomAnchor , constant: 4).isActive = true
        statusContainer.widthAnchor.constraint(equalToConstant:  160).isActive = true
        statusContainer.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
    }
    
    fileprivate func configeDate(){
        addSubview(shopDate)
        shopDate.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 8).isActive = true
        shopDate.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        shopDate.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -4).isActive = true
        
        
    }
    fileprivate func configPrice(){
        priceContainer.addSubview(gamePrice)
        gamePrice.centerXAnchor.constraint(equalTo: priceContainer.centerXAnchor).isActive = true
        gamePrice.centerYAnchor.constraint(equalTo: priceContainer.centerYAnchor).isActive = true
    }
    fileprivate func configeLabel(){
        addSubview(gameName)
        gameName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        gameName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        gameName.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -4).isActive = true
    }
    fileprivate func configeView(){
        addSubview(priceContainer)
        priceContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        priceContainer.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 4).isActive = true
//        priceContainer.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -4).isActive = true
        priceContainer.widthAnchor.constraint(equalToConstant: 110).isActive = true
        priceContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        configPrice()
    }
    fileprivate func configeImageView(){
        addSubview(gameImage)
        gameImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        gameImage.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        gameImage.widthAnchor.constraint(equalToConstant: 110 ).isActive = true
    }
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        return str
    }
    
}
