//
//  SearchPostCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/13/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

class SearchPostCell: baseCell {
     var post:Post!{
                didSet{
                    if post.photos.count != 0{
                        let url = URL(string:post.photos[0].url)
                        postImage.sd_setImage(with: url, placeholderImage:UIImage(named:"GOW"),completed: nil)
                    }else{
                        postImage.image = UIImage(named:"notFound")
                    }
                    
                    content.text = post.title
                    date.text = (UIApplication.shared.delegate as! AppDelegate).dateConvertor(from: post.created_at)
                }
            }
            let postImage:UIImageView = {
                let image = UIImage(named: "GOW")
                var iv = UIImageView(image: image)
                iv.translatesAutoresizingMaskIntoConstraints = false
                iv.contentMode = .scaleToFill
                iv.clipsToBounds = true
                return iv
            }()
            let dateContainer:UIView = {
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

            let stack:UIStackView = {
                var stack = UIStackView()
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.spacing = -15
                stack.axis = .horizontal
                stack.distribution = .fillEqually
                return stack
            }()
            let statusLabel:UILabel = {
                var label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textColor = .white
                label.text = "ادامه مطلب ..."
                label.font = UIFont(name: "IRANSans", size: 12)
                label.textAlignment = .center
                label.clipsToBounds = true
                return label
            }()
        let content:UILabel = {
                  var label = UILabel()
                  label.translatesAutoresizingMaskIntoConstraints = false
                  label.font = UIFont(name: "IRANSans", size: 12)
                  label.textAlignment = .right
                  label.textColor = .white
                  label.numberOfLines = 0
                  
                  return label
              }()
            
            let date:UILabel = {
                var label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont(name: "IRANSans", size: 13)
                label.textAlignment = .center
                label.textColor = .white
                label.text = "۱۳۹۸/۰۷/۱۲"
                return label
            }()
            var topConstraint:NSLayoutConstraint!
            var bottomConstraint:NSLayoutConstraint!
            override func setupViews() {
                layer.cornerRadius = 5
                backgroundColor = .navAndTabColor
                //confguration of all view's in cell
                configeImageView()
                configeView()
                
                configeContent()
                configDate()
                configeLeftDownView()
                configeStack()
            }
        
            fileprivate func configeStack(){
                statusContainer.addSubview(statusLabel)
                statusLabel.centerYAnchor.constraint(equalTo: statusContainer.centerYAnchor).isActive = true
                statusLabel.centerXAnchor.constraint(equalTo: statusContainer.centerXAnchor).isActive = true
            }
            fileprivate func configeLeftDownView(){
                addSubview(statusContainer)
                
                statusContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
                topConstraint = statusContainer.topAnchor.constraint(equalTo: postImage.bottomAnchor , constant: 4)
                topConstraint.isActive = true
                statusContainer.widthAnchor.constraint(equalToConstant: 100 ).isActive = true
                statusContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                topConstraint = statusContainer.leftAnchor.constraint(equalTo: leftAnchor , constant: 8)
                topConstraint.isActive = true

            }

            fileprivate func configDate(){
                dateContainer.addSubview(date)
                date.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
                date.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor).isActive = true
                
            }
            fileprivate func configeContent(){
                addSubview(content)
                content.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
                content.rightAnchor.constraint(equalTo: postImage.leftAnchor, constant: -8).isActive = true
                content.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
                content.bottomAnchor.constraint(equalTo: postImage.bottomAnchor, constant: -4).isActive = true
            }
            fileprivate func configeView(){
                addSubview(dateContainer)
                dateContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
                dateContainer.topAnchor.constraint(equalTo: postImage.bottomAnchor , constant: 4).isActive = true
                dateContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
                dateContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
            fileprivate func configeImageView(){
                addSubview(postImage)
                postImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
                postImage.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
                postImage.heightAnchor.constraint(equalToConstant: 130 ).isActive = true
                postImage.widthAnchor.constraint(equalToConstant: 100 ).isActive = true
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
