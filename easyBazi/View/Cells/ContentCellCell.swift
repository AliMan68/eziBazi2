//
//  ContentCellCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 5/20/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import UIKit

class ContentCellCell:baseCell{
    
    var post:Post!{
           didSet{
            if post.photos.count != 0{
                   let url = URL(string:post.photos[0].url)
                   postImage.sd_setImage(with: url, placeholderImage:UIImage(named:"GOW"),completed: nil)
               }else{
                   postImage.image = UIImage(named:"notFound")
               }
            postTitle.text = post.title
               
        }
       }
    
    
    
    let postImage:UIImageView = {
        let image = UIImage(named: "GOW")
        var iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 5
//        iv.backgroundColor = .orange
//        iv.layer.masksToBounds = true
        return iv
    }()
    
    let postTitle:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 2
//        label.text = "۲۰۰,۰۰۰ تومان"
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
        addSubview(postImage)
        postImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        postImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        postImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        postImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    fileprivate func setupContainer(){
        addSubview(container)
        container.heightAnchor.constraint(equalTo: postImage.heightAnchor ,multiplier: 0.5).isActive = true
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
        container.addSubview(postTitle)
        
        postTitle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        postTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        postTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        postTitle.heightAnchor.constraint(equalTo: postImage.heightAnchor ,multiplier: 0.35).isActive = true
              
    }
    
    //helper func's
   
    
}
