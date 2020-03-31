//
//  Reckoning View.swift
//  EziBazi2
//
//  Created by Ali Arabgary on 6/7/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SVProgressHUD
class ReckoningView : NSObject , UITextViewDelegate,UITextFieldDelegate{
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    let blackView = UIView()
    let blurView = UIBlurEffect(style: UIBlurEffectStyle.light)
    var game:Game!
    var font:UIFont!
    var defaultBottomConstaint:NSLayoutConstraint!
    var bottomConstaint:NSLayoutConstraint!
    var reckogningVC:ReckogningViewController!
    let containerView:UIView = {
        var view = UIView(frame: CGRect.zero)
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    let coverView:UIView = {
        var view = UIView(frame: CGRect.zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(white: 1, alpha: 0.6)
        view.layer.borderWidth = 1
        return view
    }()
    
    let textView:UITextView = {
        var post = UITextView()
        post.backgroundColor = UIColor.gray
        post.layer.borderColor = UIColor.easyBaziTheme.cgColor
        post.layer.borderWidth = 1.0
        post.layer.cornerRadius = 10
        post.textColor = UIColor.white
        post.textAlignment = .right
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.keyboardType = .default
        return post
    }()
   
    let sendBtn:UIButton = {
        var btn = UIButton()
        btn.setTitle("ارسال", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.gray
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.easyBaziTheme.cgColor
        btn.layer.cornerRadius = 4
        //        btn.addTarget(self, action: #selector(sendComment), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var paddingForInput = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    let creditCardInput:UITextField = {
      var input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.cornerRadius = 3
        input.textAlignment = .center
        input.font = UIFont(name: "San Francisco Display", size: 12)
        input.keyboardType = UIKeyboardType.numberPad
        
        return input
    }()
    let creditCardOwner:UITextField = {
        var input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.cornerRadius = 3
        input.placeholder = " مثل : علی محمدی"
        input.textAlignment = .right
        input.font = UIFont(name: "IRANSans", size: 12)
        return input
    }()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            return true
    }
    let cancelBtn:UIButton = {
        var btn = UIButton()
        btn.setTitle("انصراف", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.gray
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = UIColor.black.cgColor
        //        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    let btnsStack:UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.backgroundColor = .red
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let gitItButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("متوجه شدم.", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:15)
//        btn.titleLabel?.textColor = .red
        btn.backgroundColor = UIColor.color(red: 0, green: 150, blue: 87, alpha: 1)
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
//        btn.layer.borderColor = UIColor.black.cgColor
//        btn.layer.borderWidth = 1.0
        return btn
    }()
    let alertView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.alpha = 0
        return view
    }()
    let cancelButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("انصراف", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.textColor = UIColor.easyBaziTheme
        btn.backgroundColor = UIColor.color(red: 58, green: 58, blue: 66, alpha: 1)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        
        return btn
    }()
    
    let cardImage:UIImageView = {
       var img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 23))
        img.image = UIImage(named: "GOW")
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 2
        return img
    }()
    let alertLabel : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "لطفا ورودی ها را مجددا بررسی فرمایید !"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .center
        return label
    }()
    let condition0 : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = " - تکمیل یکی از موارد شماره حساب یا شماره کارت یا شماره شبا الزامی می باشد."
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 12)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    let reckoningInfo : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = " نکات تسویه حساب"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 17)
        label.textAlignment = .center
        return label
    }()
    let condition4 : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "- حداقل موجودی برای تسویه حساب ۱۰،۰۰۰ تومان می باشد."
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 12)
        label.numberOfLines = 0
        return label
    }()
    let paddingView : UIView = {
        var label = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let paddingView2 : UIView = {
        var label = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let conditionLabel1 : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = " - مبلغ تسویه حساب حداکثر ظرف مدت ۷۲ ساعت واریز خواهد شد."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 12)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    let conditionLabel2 : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = " - برای دریافت اطلاعات بیشتر با پشتیبانی در ارتباط باشید."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 12)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    
    //show commentView Here
    fileprivate func configeContainerView(inside window:UIWindow){
        bottomConstaint = containerView.topAnchor.constraint(equalTo:window.topAnchor , constant: 16)
        defaultBottomConstaint = containerView.topAnchor.constraint(equalTo:window.bottomAnchor , constant: 16)
        NSLayoutConstraint.activate([
            bottomConstaint,
            containerView.rightAnchor.constraint(equalTo: window.rightAnchor, constant: -16),
            containerView.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 16),
            containerView.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: 0.6)
            ])
    }
    override init() {
        super.init()
        creditCardInput.delegate = self
    }
    
    
    public func show(){
        if let window = UIApplication.shared.keyWindow{
            font = UIFont(name: "San Francisco Display", size: 13)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0
            window.addSubview(blackView)
//            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            blackView.frame = window.frame
            window.addSubview(containerView)
//            configeContainerView(inside: window)
            containerView.frame = CGRect(x: 20, y: window.frame.height, width: window.frame.width - 40, height: window.frame.height * 0.52)
            configeViews()
            let yPosition:CGFloat = UIApplication.shared.statusBarFrame.height * 2
            UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.containerView.frame = CGRect(x: 20.0, y: yPosition, width: window.frame.width - 40, height: window.frame.height * 0.52)
                
            }, completion: nil)
        }
    }
    
    //dismiss comment view
    @objc func dismiss() {
        textView.text = ""
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: 20.0, y:window.frame.height, width: window.frame.width - 40, height: window.frame.height * 0.52)
                window.endEditing(true)
                self.coverView.removeFromSuperview()
            }
        }, completion: nil)
        reckogningVC.fullNameInput.becomeFirstResponder()
    }
    
    
    //config container view's
    fileprivate func configeViews(){
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.gray,
            NSAttributedStringKey.font : font
        ]
        
        btnsStack.addArrangedSubview(gitItButton)
        creditCardInput.leftViewMode = .always
        creditCardInput.leftView = paddingView
        creditCardInput.rightViewMode = .always
        creditCardInput.rightView = paddingView
        creditCardInput.attributedPlaceholder = NSAttributedString(string: "XXXX - XXXX - XXXX - XXXX", attributes: attributes as [NSAttributedStringKey : Any])
        containerView.addSubview(reckoningInfo)
        containerView.addSubview(condition0)
//        containerView.addSubview(creditCardInput)
        containerView.addSubview(condition4)
//        containerView.addSubview(creditCardOwner)
        containerView.addSubview(conditionLabel1)
        containerView.addSubview(conditionLabel2)
        containerView.addSubview(btnsStack)
        
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        gitItButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        creditCardOwner.leftViewMode = .always
        creditCardOwner.leftView = paddingView2
        NSLayoutConstraint.activate([
            reckoningInfo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            reckoningInfo.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            reckoningInfo.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            
            condition0.topAnchor.constraint(equalTo: reckoningInfo.bottomAnchor, constant: 16),
            condition0.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            condition0.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
//            condition0.heightAnchor.constraint(equalToConstant: 55),

            
            condition4.topAnchor.constraint(equalTo: condition0.bottomAnchor, constant: 24),
            condition4.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            condition4.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
           
            
            conditionLabel1.topAnchor.constraint(equalTo: condition4.bottomAnchor, constant: 16),
            conditionLabel1.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            conditionLabel1.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            conditionLabel2.topAnchor.constraint(equalTo: conditionLabel1.bottomAnchor, constant: 12),
            conditionLabel2.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            conditionLabel2.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            
            btnsStack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 32),
            btnsStack.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -32),
            btnsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            btnsStack.heightAnchor.constraint(equalToConstant: 40)
            
            ])
        if containerView.frame.width > 374 - 40 {
            condition4.font = UIFont(name:"IRANSans", size: 13)
            condition0.font = UIFont(name:"IRANSans", size: 13)
            conditionLabel2.font = UIFont(name:"IRANSans", size: 13)
            conditionLabel1.font = UIFont(name:"IRANSans", size: 13)
        }
        creditCardInput.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
    }
    @objc func handleRequest(){
            dismiss()
        
//            if creditCardInput.text == "" || creditCardOwner.text == ""{
//                if let window = UIApplication.shared.keyWindow {
//                    window.endEditing(true)
//
//                    window.addSubview(alertView)
//
//                    //confige alert view here
//                    alertView.addSubview(alertLabel)
//                    let alertLabelFram = NSString(string: alertLabel.text!).boundingRect(with: CGSize(width: (window.frame.width) - 54, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
//                    NSLayoutConstraint.activate([
//                        alertView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
//                        alertView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24),
//                        alertView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24),
//                        alertView.heightAnchor.constraint(equalToConstant: alertLabelFram.height + 24),
//                        alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 8),
//                        alertLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -8),
//                        alertLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 8)
//                        ])
//                }
//
//
//                UIView.animate(withDuration: 0.6, animations: {
//                    self.alertView.alpha = 1
//                }, completion: nil)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    UIView.animate(withDuration: 0.6, animations: {
//                        self.alertView.alpha = 0
//                    }, completion: nil)
//                }
//            }else{
//
//                addCoverView()
//            }
    }
    
    
    fileprivate func addCoverView(){
        coverView.backgroundColor = UIColor(white: 1, alpha: 0.6)
        coverView.alpha = 0
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.tintColor = UIColor.easyBaziTheme
        indicator.color = UIColor.easyBaziTheme
        containerView.addSubview(coverView)
        coverView.frame = containerView.bounds
        coverView.addSubview(indicator)
        indicator.frame = coverView.bounds
        indicator.center = coverView.center
        indicator.startAnimating()
        UIView.animate(withDuration: 0.4, animations: {
            self.coverView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func removeCoverView(){
        UIView.animate(withDuration: 0.4, animations: {
            self.coverView.alpha = 0
        }, completion: { finish in
            self.coverView.removeFromSuperview()
        })
    }
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces

        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")

        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                
                stringWithAddedSpaces.append(" - ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 3
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
 
    
    
    
    
}
