//
//  increaseAccountBalance.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/13/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SVProgressHUD
class IncreaseAccountBalance : NSObject , UITextViewDelegate,UITextFieldDelegate{
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
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
    let increaseAmount:UITextField = {
        var input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.cornerRadius = 3
        input.placeholder = "مبلغ را به تومان وارد کنید."
        var attr = NSAttributedString(string: "مبلغ را به تومان وارد کنید.", attributes: [NSAttributedStringKey.font  :UIFont(name: "IRANSans", size: 14)! , NSAttributedStringKey.foregroundColor  : UIColor.darkGray
        ])
        input.attributedPlaceholder = attr
        input.textAlignment = .center
        input.font = UIFont(name: "IRANSans", size: 14)
        input.keyboardType = .asciiCapableNumberPad
        return input
    }()

    let cancelBtn:UIButton = {
        var btn = UIButton()
        btn.setTitle("انصراف", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 5
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
    
    let increaseButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("افزایش", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:14)
        btn.titleLabel?.textColor = .red
        btn.backgroundColor = UIColor.easyBaziGreen
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        
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
    let alertLabel : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "لطفا ورودی را مجددا بررسی فرمایید !"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .center
        return label
    }()
    let reckoningInfo : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "افزایش موجودی حساب"
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
    let conditionLabel1 : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = " - حداقل مبلغ برای افزایش اعتبار ۱۰۰۰ تومان می باشد."
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
        increaseAmount.delegate = self
    }
    
    
    public func show(){
        if let window = UIApplication.shared.keyWindow{
            font = UIFont(name: "San Francisco Display", size: 13)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            blackView.alpha = 0
            window.addSubview(blackView)
//            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            blackView.frame = window.frame
            window.addSubview(containerView)
//            configeContainerView(inside: window)
            containerView.frame = CGRect(x: 20, y: window.frame.height, width: window.frame.width - 40, height: window.frame.height * 0.42)
            configeViews()
            let yPosition:CGFloat = UIApplication.shared.statusBarFrame.height * 2
            UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.containerView.frame = CGRect(x: 20.0, y: yPosition, width: window.frame.width - 40, height: window.frame.height * 0.42)
                
            }, completion: nil)
            increaseAmount.becomeFirstResponder()
        }
    }
    
    //dismiss comment view
    @objc func dismiss() {
        textView.text = ""
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.containerView.frame = CGRect(x: 20.0, y:window.frame.height, width: window.frame.width - 40, height: window.frame.height * 0.42)
                window.endEditing(true)
                self.coverView.removeFromSuperview()
            }
        }, completion: nil)
    }
   
    //config container view's
    fileprivate func configeViews(){
        btnsStack.addArrangedSubview(cancelBtn)
        btnsStack.addArrangedSubview(increaseButton)
        containerView.addSubview(reckoningInfo)
        containerView.addSubview(increaseAmount)
        containerView.addSubview(conditionLabel1)
        containerView.addSubview(conditionLabel2)
        containerView.addSubview(btnsStack)
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        increaseAmount.leftViewMode = .always
        increaseAmount.leftView = paddingView2
        NSLayoutConstraint.activate([
            reckoningInfo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            reckoningInfo.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            reckoningInfo.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            increaseAmount.topAnchor.constraint(equalTo: reckoningInfo.bottomAnchor, constant: 16),
            increaseAmount.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            increaseAmount.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            increaseAmount.heightAnchor.constraint(equalToConstant: 50),
            
            conditionLabel1.topAnchor.constraint(equalTo: increaseAmount.bottomAnchor, constant: 20),
            conditionLabel1.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            conditionLabel1.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            conditionLabel2.topAnchor.constraint(equalTo: conditionLabel1.bottomAnchor, constant: 12),
            conditionLabel2.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            conditionLabel2.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            
            btnsStack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            btnsStack.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            btnsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
            
            ])
        if containerView.frame.width > 374 - 40 {
            conditionLabel2.font = UIFont(name:"IRANSans", size: 13)
            conditionLabel1.font = UIFont(name:"IRANSans", size: 13)
        }
    }
    
    func handleAlert(){
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
    }
    
    @objc func handleRequest(){
        
        
            if increaseAmount.text == ""{//check if input is empty
                handleAlert()
            }else{
                increaseCredit()
            }
    }
    

    
     internal func increaseCredit(){
        SVProgressHUD.setFont(font)
        addCoverView()

        if increaseAmount.text != ""{
            IncreaseCredit.pay(token: self.getToken(),amount:increaseAmount.text! ,completion: { (status, message,link) in
                if status == 1 {

                    if link != ""{
                            self.profileVC.increaseCredit(with:link)
                            
                            self.dismiss()
                            self.removeCoverView()
                            self.increaseAmount.text = ""
                        }else{
                            SVProgressHUD.showError(withStatus: "خطایی رخ داده!")
                            SVProgressHUD.dismiss(withDelay: 2)
                            self.dismiss()
                            self.removeCoverView()
                            self.increaseAmount.text = ""
                    }
                   
                }else{
                    SVProgressHUD.showError(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 3)
                    self.dismiss()
                }
            })
        }else{

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
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//          var temp:Bool = false
//          if textField == increaseAmount{
//            let maxLength = 10
//            let currentString: NSString = textField.text! as NSString
//            let currentStringToInt = Int(currentString as String)?.formattedWithSeparator
//            print("currentStringToInt = \(currentStringToInt)")
//            print("string = \(string)")
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            temp = newString.length <= maxLength
//          }
//          return temp
//      }
//
//    func convertToPersian(inputStr:String)-> String {
//        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
//        var str : String = inputStr
//
//        for (key,value) in numbersDictionary {
//            str =  str.replacingOccurrences(of: key, with: value)
//        }
//
//        return str
//    }
}
