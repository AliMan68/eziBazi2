//
//  SearchShopCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/12/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

class SearchShopCell: baseCell {
        var game:Game!{
            didSet{
                if game.game_info.photos.count != 0{
                           let url = URL(string: game.game_info.photos[0].url)
                               gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
                           }else{
                               gameImage.image = UIImage(named:"GOW")
                           }
                
                
                gameName.text = game.game_info.name
                
                //extract genres here
                if game.game_info.genres.count != 0{
                               if game.game_info.genres.count > 1{
                                 for genre in game.game_info.genres{
                                     if genre.name == game.game_info.genres[0].name{
                                       gameGenre.text = genre.name
                                     }else{
                                       gameGenre.text = gameGenre.text! + "," + genre.name
                                     }
               
                                     }
                                 }else{
                                     gameGenre.text = game.game_info.genres[0].name
                                 }
                           }else{
                               gameGenre.text = "ندارد !"
                           }
                
                gamePrice.text = convertToPersian(inputStr: String(describing: Int(game.price).formattedWithSeparator)) + " تومان"
    
                if game.count == 0{
                                statusLabel.text = "ناموجود"
                                gamePrice.textColor = .notAvailable
                                gamePrice.text = "ناموجود"
                                statusImage.image = UIImage(named: "finished")
                            }else{
                                statusImage.image = UIImage(named: "availabel")
                                statusLabel.text = "موجود"
                           }
                gameRegion.text = convertToPersian(inputStr: game.region)
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
            v.backgroundColor = .clear
            return v
        }()
        let stack:UIStackView = {
            var stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = -15
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
            label.font = UIFont(name: "IRANSans", size: 14)
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
    let gameNameLabel:UILabel = {
              var label = UILabel()
              label.translatesAutoresizingMaskIntoConstraints = false
              label.font = UIFont(name: "IRANSans", size: 13)
              label.textAlignment = .right
              label.textColor = .white
              label.text = "نام :"
              return label
          }()
        let gameRegion:UILabel = {
            var label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "IRANSans", size: 15)
            label.textAlignment = .left
            label.textColor = UIColor(white: 1, alpha: 1)
            label.text = " 2"
            return label
        }()
    let gameRegionLabel:UILabel = {
             var label = UILabel()
             label.translatesAutoresizingMaskIntoConstraints = false
             label.font = UIFont(name: "IRANSans", size: 13)
             label.textAlignment = .left
             label.textColor = UIColor(white: 1, alpha: 1)
             label.text = "ریجن :"
             return label
         }()
    
    
     let gameGenreLabel:UILabel = {
              var label = UILabel()
              label.translatesAutoresizingMaskIntoConstraints = false
              label.font = UIFont(name: "IRANSans", size: 13)
              label.textAlignment = .left
              label.textColor = UIColor(white: 1, alpha: 1)
              label.text = "ژانر :"
              return label
          }()
     let gameGenre:UILabel = {
               var label = UILabel()
               label.translatesAutoresizingMaskIntoConstraints = false
               label.font = UIFont(name: "IRANSans", size: 13)
               label.textAlignment = .left
               label.textColor = UIColor(white: 1, alpha: 1)
               label.text = ""
               return label
           }()
    
//        let rentperiod:UILabel = {
//            var label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.font = UIFont(name: "IRANSans", size: 15)
//            label.textAlignment = .left
//            label.textColor = UIColor(white: 1, alpha: 1)
//            label.text = "زمان : ۷ روزه"
//            return label
//        }()
        
        let gamePrice:UILabel = {
            var label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "IRANSans", size: 13)
            label.textAlignment = .center
            label.textColor = .white
            label.text = "۲۰۰.۰۰۰ تومان"
            return label
        }()
        var topConstraint:NSLayoutConstraint!
        var bottomConstraint:NSLayoutConstraint!
        override func setupViews() {
            layer.cornerRadius = 5
            backgroundColor = .navAndTabColor
            configeImageView()
            configeView()
            configeLabel()
            configPrice()
            configeRegion()
            configeGenre()
            //      configerentperiod()
            configeLeftDownView()
            //      configeCircle()
            configeStack()
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
                    topConstraint = statusContainer.topAnchor.constraint(equalTo: gameImage.bottomAnchor , constant: 4)
                    topConstraint.isActive = true
                    statusContainer.widthAnchor.constraint(equalToConstant: 100 ).isActive = true
                    statusContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    
                    topConstraint = statusContainer.leftAnchor.constraint(equalTo: leftAnchor , constant: 8)
                    topConstraint.isActive = true

                }
                
                fileprivate func configeRegion(){
                    addSubview(gameRegion)
                             addSubview(gameRegionLabel)
                    gameRegionLabel.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -8).isActive = true
                    gameRegionLabel.centerYAnchor.constraint(equalTo: gameImage.centerYAnchor, constant: 0).isActive = true
                    gameRegion.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
                    gameRegion.centerYAnchor.constraint(equalTo: gameImage.centerYAnchor, constant: 0).isActive = true
                            
                             
                             
                }

                fileprivate func configPrice(){
                    priceContainer.addSubview(gamePrice)
                    gamePrice.centerXAnchor.constraint(equalTo: priceContainer.centerXAnchor).isActive = true
                    gamePrice.centerYAnchor.constraint(equalTo: priceContainer.centerYAnchor).isActive = true
                    
                }
                fileprivate func configeLabel(){
                        addSubview(gameName)
                        addSubview(gameNameLabel)
                        gameName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
                        gameName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
                        gameNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
                        gameNameLabel.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -8).isActive = true
                }
                fileprivate func configeView(){
                    addSubview(priceContainer)
                    priceContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
                    priceContainer.topAnchor.constraint(equalTo: gameImage.bottomAnchor , constant: 4).isActive = true
                    priceContainer.widthAnchor.constraint(equalToConstant: 90).isActive = true
                    priceContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
                }
                fileprivate func configeGenre(){
                       addSubview(gameGenre)
                        addSubview(gameGenreLabel)
                        gameGenreLabel.rightAnchor.constraint(equalTo: gameImage.leftAnchor, constant: -8).isActive = true
                    gameGenreLabel.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 0).isActive = true
                    gameGenre.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
                    gameGenre.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 0).isActive = true
                   }
                fileprivate func configeImageView(){
                    addSubview(gameImage)
                    gameImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
                    gameImage.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
                    gameImage.heightAnchor.constraint(equalToConstant: 130 ).isActive = true
                    gameImage.widthAnchor.constraint(equalToConstant: 90 ).isActive = true
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
