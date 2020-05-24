//
//  ActivityRentCell.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/11/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate {
    func renewalButtonPressed(cell:ActivityRentCell)
}


class ActivityRentCell: baseCell {
    var delegate:CollectionViewCellDelegate?
    var rentCollectioView:ActivityViewController!
    var game:RentedGameData!{
        didSet{
            if game.game_for_rent.game_info.photos.count != 0{
                let url = URL(string:game.game_for_rent.game_info.photos[0].url)
                gameImage.sd_setImage(with: url, placeholderImage:UIImage(named:"GOW"),completed: nil)
            }else{
                gameImage.image = UIImage(named:"notFound")
            }
            
            gameName.text = game.game_for_rent.game_info.name!.uppercased()
            gameRentPrice.text = convertToPersian(inputStr: String(describing: Int(game.rent_price).formattedWithSeparator)) + " تومان"
            //calculate rent time in day's
            circleContainer.rentPeriod = CGFloat(dateDiff(start: game.created_at, finish: game.finished_at))
//            print("this is rent period = \(circleContainer.rentPeriod )")
            //diff between now and rent finish date
            circleContainer.remainDays = CGFloat(dateDiffFromNow(to: game.finished_at)) + 1
//            print("this is rent remained = \(circleContainer.remainDays)")
            circleContainer.layoutIfNeeded()
            
            rentDate.text = (UIApplication.shared.delegate as! AppDelegate).dateConvertor(from: game.created_at)
            
            if(game.is_finish == 1) {
                         statusLabel.text = "بسته شده است."
                        statusImage.image = UIImage(named: "finished")
                             }
            else if(game.is_finish == 0 && game.is_returned == 1){
                         statusLabel.text = "تحویل گردید."
                statusImage.image = UIImage(named: "deliverd")
                             }
            else if(game.is_finish == 0 && game.is_returned == 0 && game.is_sent == 1){
                     statusLabel.text = "در حال ارسال..."
                     statusImage.image = UIImage(named: "delivery")
                             }
            else if(game.is_finish == 0 && game.is_returned == 0 && game.is_sent == 0){
                     statusLabel.text = "در حال ارسال..."
                     statusImage.image = UIImage(named: "delivery")
                             }
        }
    }
  
    let renewal:UIButton = {
        var btn = UIButton()
        btn.setTitle("تمدید", for: UIControlState.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
        btn.backgroundColor = .easyBaziGreen
        return btn
    }()
    @objc func hanedleRenewal(sender:UIButton){
        delegate?.renewalButtonPressed(cell: self)
    }
    let gameImage:UIImageView = {
        let image = UIImage(named: "GOW")
        var iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 2
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
        v.backgroundColor = .clear
        return v
    }()
    let stack:UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
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
        label.font = UIFont(name: "IRANSans", size: 9)
        label.textAlignment = .right
        return label
    }()
    
    let gameName:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "San Francisco Display", size: 16)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "RED DEAD REDEMPTION2"
        return label
    }()
    let rentDate:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 12)
        label.textAlignment = .left
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.text = "۱۳۹۷/۱۲/۱۰"
        return label
    }()
    let rentDateLabel:UILabel = {
         var label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont(name: "IRANSans", size: 12)
         label.textAlignment = .left
         label.textColor = UIColor(white: 1, alpha: 0.8)
         label.text = "تاریخ : "
         return label
     }()
    let gameRentPrice:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "۲۰۰.۰۰۰ تومان"
        return label
    }()
    override func setupViews() {
        backgroundColor = .navAndTabColor
        //confguration of all view's in cell
//        circleContainer.rentPeriod = 30
//        circleContainer.remainDays = 10
        renewal.addTarget(self, action: #selector(hanedleRenewal(sender:)), for: .touchUpInside)
        configeImageView()
        configePriceView()
//
        configeLabel()
        configPrice()
        configeDate()
        configeCircle()
        configeLeftDownView()
        configeStack()
        configeRenewal()
    }
    fileprivate func buttonBorderAnimation(for button:UIButton) {
          let animation1 = CABasicAnimation(keyPath: "borderColor")
          animation1.fromValue = UIColor.cyan.cgColor
          animation1.toValue = UIColor.easyBaziTheme.cgColor
          animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
          animation1.repeatCount = .infinity
          animation1.duration = 1
          animation1.autoreverses = true
//          animation1.isRemovedOnCompletion = true
          button.layer.add(animation1, forKey: nil)
      }
    
    fileprivate func configeRenewal(){
        addSubview(renewal)
        renewal.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        renewal.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        renewal.topAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: 8).isActive = true
        renewal.layer.borderWidth = 2
        renewal.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
        buttonBorderAnimation(for: renewal)
    }
    fileprivate func configeStack(){
        statusContainer.addSubview(stack)
        stack.addArrangedSubview(statusLabel)
        stack.addArrangedSubview(statusImage)
        stack.leftAnchor.constraint(equalTo: statusContainer.leftAnchor, constant: 0).isActive = true
        stack.rightAnchor.constraint(equalTo: statusContainer.rightAnchor, constant: 0).isActive = true
        stack.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 0).isActive = true
        stack.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: 0).isActive = true
        
    }
    fileprivate func configeLeftDownView(){
        addSubview(statusContainer)
        statusContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        statusContainer.topAnchor.constraint(equalTo: circleContainer.bottomAnchor , constant: 4).isActive = true
        statusContainer.widthAnchor.constraint(equalToConstant: 140 ).isActive = true
        statusContainer.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
    }

    
    fileprivate func configeDate(){
        addSubview(rentDate)
        addSubview(rentDateLabel)
        rentDateLabel.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 4).isActive = true
        //        rentDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        rentDateLabel.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -4).isActive = true
        rentDate.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 4).isActive = true
        rentDate.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        rentDate.rightAnchor.constraint(equalTo: rentDateLabel.leftAnchor, constant: -8).isActive = true
        
    }

    fileprivate func configeCircle(){
        addSubview(circleContainer)
//        circleContainer.clipsToBounds = true
        circleContainer.topAnchor.constraint(equalTo: rentDate.bottomAnchor, constant: 4).isActive = true
        circleContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        circleContainer.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor ,constant: 0).isActive = true
        circleContainer.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    fileprivate func configPrice(){
        priceContainer.addSubview(gameRentPrice)
        gameRentPrice.centerXAnchor.constraint(equalTo: priceContainer.centerXAnchor).isActive = true
        gameRentPrice.centerYAnchor.constraint(equalTo: priceContainer.centerYAnchor).isActive = true
        
    }
    fileprivate func configeLabel(){
        addSubview(gameName)
        gameName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        gameName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        gameName.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -4).isActive = true
//        gameName.centerXAnchor.constraint(equalTo: circleContainer.centerXAnchor).isActive = true
    }
    fileprivate func configePriceView(){
        addSubview(priceContainer)
        priceContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        priceContainer.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 4).isActive = true
//        priceContainer.bottomAnchor.constraint(equalTo: renewal.topAnchor , constant: -4).isActive = true
        priceContainer.widthAnchor.constraint(equalToConstant: 120  ).isActive = true
        priceContainer.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
    }
    fileprivate func configeImageView(){
        addSubview(gameImage)
        gameImage.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        gameImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: 170).isActive = true
        gameImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    func convertToPersian(inputStr:String)-> String {
                let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
                var str : String = inputStr
                for (key,value) in numbersDictionary {
                    str =  str.replacingOccurrences(of: key, with: value)
                }
                return str
            }

    func dateDiffFromNow(to date:String)->Int{
         let date = String(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateInGrogrian = dateFormatter.date(from: date)
        let userCalendar = Calendar.current
        let requestedComponent: Set<Calendar.Component> = [.day]
//        dateFormatter.dateFormat = "yyyy/MM/yy hh:mm:ss"
        let startTime = timeRightNow()
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: dateInGrogrian!)
        return timeDifference.day! > 0 ? timeDifference.day! : 0
        
    }
    func dateDiff(start:String, finish:String)->Int{
         let date = String(start)
        let date2 = String(finish)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateInGrogrian = dateFormatter.date(from: date)
        let date2InGrogrian = dateFormatter.date(from: date2)
        let userCalendar = Calendar.current
        let requestedComponent: Set<Calendar.Component> = [.day]
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: dateInGrogrian!, to: date2InGrogrian!)
        return timeDifference.day ?? 1
    }
    
    func timeRightNow()->Date{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/DD hh:mm:ss"
        return date
    }

}
