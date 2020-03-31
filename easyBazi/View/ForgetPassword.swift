//
//  ForgetPassword.swift
//  EziBazi2
//
//  Created by Ali Arabgary on 7/25/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SVProgressHUD
class ForgetPassword : NSObject , UITextViewDelegate,UITextFieldDelegate{
    let blackView = UIView()
    let blurView = UIBlurEffect(style: UIBlurEffectStyle.light)
    var game:Game!
    var font:UIFont!
    var profileVC:ProfileController!
    var defaultBottomConstaint:NSLayoutConstraint!
    var bottomConstaint:NSLayoutConstraint!
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
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.easyBaziTheme.cgColor
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
    let mobileNumberInput:UITextField = {
        var input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.cornerRadius = 3
        input.textAlignment = .center
        input.font = UIFont(name: "San Francisco Display", size: 14)
        input.keyboardType = UIKeyboardType.asciiCapableNumberPad
        return input
    }()
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
    
    let sendVerificationCodeButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("بازیابی رمز", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:12)
        btn.titleLabel?.textColor = .red
        btn.backgroundColor = UIColor.color(red: 0, green: 150, blue: 87, alpha: 1)
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.0
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
        label.text = "لطفا ورودی ها را مجددا بررسی فرمایید. !"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .center
        return label
    }()
    let cardLabel : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "آدرس ایمیل :"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 11)
        label.textAlignment = .right
        return label
    }()
    let reckoningInfo : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "بازیابی رمز عبور"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 17)
        label.textAlignment = .center
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
    
    let conditionLabel : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = " - کد ۵ رقمی به شماره شما فرستاده می شود."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 12)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    
    //show commentView Here
    fileprivate func configeContainerView(inside window:UIWindow){
        SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 13)!) 
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
        mobileNumberInput.delegate = self
    }
    
    
    public func show(){
        if let window = UIApplication.shared.keyWindow{
            font = UIFont(name: "San Francisco Display", size: 13)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            blackView.alpha = 0
            window.addSubview(blackView)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            blackView.frame = window.frame
            window.addSubview(containerView)
            //            configeContainerView(inside: window)
            containerView.frame = CGRect(x: 20, y: -window.frame.height, width: window.frame.width - 40, height: window.frame.height * 0.38)
            configeViews()
            let yPosition:CGFloat = UIApplication.shared.statusBarFrame.height * 2
            UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.containerView.frame = CGRect(x: 20.0, y: yPosition, width: window.frame.width - 40, height: window.frame.height * 0.38)
                
            }, completion: nil)
            mobileNumberInput.becomeFirstResponder()
        }
    }
    
    //dismiss comment view
    @objc func dismiss() {
        textView.text = ""
        mobileNumberInput.text = ""
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: 20.0, y:window.frame.height, width: window.frame.width - 40, height: window.frame.height * 0.38)
                window.endEditing(true)
                self.coverView.removeFromSuperview()
            }
        }, completion: nil)
    }
    
    
    //config container view's
    fileprivate func configeViews(){
        font = UIFont(name: "IRANSans", size: 13)
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.gray,
            NSAttributedStringKey.font : font
        ]
        btnsStack.addArrangedSubview(cancelBtn)
        btnsStack.addArrangedSubview(sendVerificationCodeButton)
        mobileNumberInput.leftViewMode = .always
        mobileNumberInput.leftView = paddingView
        mobileNumberInput.rightViewMode = .always
        mobileNumberInput.rightView = paddingView
        mobileNumberInput.attributedPlaceholder = NSAttributedString(string: " شماره موبایل", attributes:attributes as [NSAttributedStringKey : Any] )
        containerView.addSubview(reckoningInfo)
        containerView.addSubview(mobileNumberInput)
       
        containerView.addSubview(conditionLabel)
        containerView.addSubview(conditionLabel2)
        containerView.addSubview(btnsStack)
        
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        sendVerificationCodeButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
    
        NSLayoutConstraint.activate([
            reckoningInfo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            reckoningInfo.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            reckoningInfo.leftAnchor.constraint(equalTo: containerView.leftAnchor),
          
            mobileNumberInput.topAnchor.constraint(equalTo: reckoningInfo.bottomAnchor, constant: 16),
            mobileNumberInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            mobileNumberInput.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            mobileNumberInput.heightAnchor.constraint(equalToConstant: 33),
            
            conditionLabel.topAnchor.constraint(equalTo: mobileNumberInput.bottomAnchor, constant: 12),
            conditionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            conditionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            
            
            conditionLabel2.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 12),
            conditionLabel2.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            conditionLabel2.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            
            btnsStack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            btnsStack.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            btnsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
            
            ])
        if containerView.frame.width > 374 - 40 {
            cardLabel.font = UIFont(name:"IRANSans", size: 13)
            conditionLabel2.font = UIFont(name:"IRANSans", size: 13)
            conditionLabel.font = UIFont(name:"IRANSans", size: 13)
        }
        
    }
    @objc func handleRequest(){
        
        
        if mobileNumberInput.text == ""{
            if let window = UIApplication.shared.keyWindow {
                window.endEditing(true)
                
                window.addSubview(alertView)
                
                //confige alert view here
                alertView.addSubview(alertLabel)
                let alertLabelFram = NSString(string: alertLabel.text!).boundingRect(with: CGSize(width: (window.frame.width) - 54, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
                NSLayoutConstraint.activate([
                    alertView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
                    alertView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24),
                    alertView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24),
                    alertView.heightAnchor.constraint(equalToConstant: alertLabelFram.height + 24),
                    alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 8),
                    alertLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -8),
                    alertLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 8)
                    ])
            }
            
            
            UIView.animate(withDuration: 0.6, animations: {
                self.alertView.alpha = 1
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.6, animations: {
                    self.alertView.alpha = 0
                }, completion: nil)
            }
        }else{
            SVProgressHUD.show(withStatus: "در حال ارسال کد تایید...")
            SVProgressHUD.dismiss(withDelay: 3)
            VerificationCode.sendForResetPassword(mobileNumberInput.text!) { (status, message) in
                if status == 1{
                    SVProgressHUD.showSuccess(withStatus: message)
//                    SVProgressHUD.dismiss(withDelay: )
                    self.profileVC.pushForgetPasswordVC(number: self.mobileNumberInput.text!)
                    self.dismiss()
                    
                }else{
                    SVProgressHUD.showSuccess(withStatus: message)
                    SVProgressHUD.dismiss(withDelay:2 )
                }
            }
            
            
            
            
//            addCoverView()
        }
    }
    
    //check if user is loggedIn
    func getToken()->String{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        var token = ""
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                // print(data.value(forKey: "token")!)
                token = data.value(forKey: "token") as! String
            }
            print("Fetching Seccessfully")
        }catch{
            print("Fetching Error")
        }
        return token
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
}

