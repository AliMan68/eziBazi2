//
//  IntroCell.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/10/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit

class IntroCell: UICollectionViewCell {
    
    let imageView:UIWebView = {
       let iv = UIWebView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.backgroundThem
//        iv.scrollView.isScrollEnabled = false
        return iv
    }()
    
    let topContainer:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.backgroundThem
        return view
    }()
    
    let textView:UITextView = {
      let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        var attribute = NSMutableAttributedString(string: "ارسال رایگان", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont(name: "IRANSans", size: 17)!])
        attribute.append(NSAttributedString(string: "\n\nبزرگترین پلتفرم خرید و فروش یازی های کنسولی ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font:UIFont(name: "IRANSans", size: 15)!]))
        tv.attributedText = attribute
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
        topContainer.addSubview(imageView)
        setupImageViewConstraint()
        addSubview(textView)
        setupTextView()
        // background theme
        backgroundColor = UIColor.backgroundThem
    }

    fileprivate func setupTextView(){
        textView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    fileprivate func setupTopContainerConstraint(){
        topContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2).isActive = true
    }
    fileprivate func setupImageViewConstraint(){
        imageView.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: topContainer.widthAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalTo: topContainer.heightAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

