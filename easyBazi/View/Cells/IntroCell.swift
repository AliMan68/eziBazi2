//
//  IntroCell.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/10/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

class IntroCell: UICollectionViewCell {
    
    let webView:UIWebView = {
       let iv = UIWebView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.backgroundThem
        iv.scrollView.isScrollEnabled = false
        return iv
    }()
       let imageView:UIImageView = {
           let iv = UIImageView(image: UIImage(named: "logo-1"))
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.backgroundColor = UIColor.clear
            iv.contentMode = .scaleAspectFit
            return iv
        }()
    
    let topContainer:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.backgroundThem
        return view
    }()
    
    let title:UITextView = {
      let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: "IRANSans", size: 20)!
//        var attribute = NSMutableAttributedString(string: "ارسال رایگان", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont(name: "IRANSans", size: 17)!])
//        attribute.append(NSAttributedString(string: "\n\nبزرگترین پلتفرم خرید و فروش یازی های کنسولی ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font:UIFont(name: "IRANSans", size: 15)!]))
//        tv.attributedText = attribute
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isEditable = false
        tv.textAlignment = .center
        tv.isScrollEnabled = false
        return tv
    }()
    let explanation:UITextView = {
      let tv = UITextView()
        tv.font = UIFont(name: "IRANSans", size: 17)!
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = .white
//        var attribute = NSMutableAttributedString(string: "ارسال رایگان", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont(name: "IRANSans", size: 17)!])
//        attribute.append(NSAttributedString(string: "\n\nبزرگترین پلتفرم خرید و فروش یازی های کنسولی ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font:UIFont(name: "IRANSans", size: 15)!]))
//        tv.attributedText = attribute
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.textAlignment = .center
        tv.isScrollEnabled = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topContainer)
        setupTopContainerConstraint()
        topContainer.addSubview(webView)
        setupImageViewConstraint()
        addSubview(title)
        addSubview(explanation)
        setupTextView()
        // background theme
        backgroundColor = UIColor.backgroundThem
    }

    fileprivate func setupTextView(){
        title.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
//        title.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        explanation.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16).isActive = true
        explanation.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        explanation.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    fileprivate func setupTopContainerConstraint(){
        topContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2).isActive = true
    }
    var webViewWidth:NSLayoutConstraint!
    var imageViewWidth:NSLayoutConstraint!
    fileprivate func setupImageViewConstraint(){
        webView.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        webViewWidth = webView.widthAnchor.constraint(equalTo: topContainer.widthAnchor, constant: 0)
        webView.heightAnchor.constraint(equalTo: topContainer.heightAnchor, constant: 0).isActive = true
        webView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        webViewWidth.isActive = true
        
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        imageViewWidth = imageView.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 1/2)
        imageView.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 1/2).isActive = true
        imageView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        imageViewWidth.isActive = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

