//
//  VerificationViewController.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/2/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class VerificationViewController: UIViewController,UITextFieldDelegate {
    
//    let verificationView:KWVerificationCodeView = {
//       var view = KWVerificationCodeView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .lightGray
//        view.underlineColor = .easyBaziTheme
//        return view
//    }()
    
    var phoneNumber:String!
    
    var isForSignup:Bool!
    
    var isForReckogning:Bool!
    
    var timer:Timer?
    
    var timeLeft = 60
    
    var tapGesture:UITapGestureRecognizer!
    
    var verificationCode:String!
    
     let exit:UIButton = {
           var btn = UIButton()
            btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
            btn.backgroundColor = .clear
            btn.setImage(UIImage(named: "exit"), for: UIControlState.normal)
            btn.imageView?.contentMode = .scaleToFill
            btn.setTitleColor(.white, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(hanldeExit), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
    let renewalDetailesLabel:UILabel = {
        var label = UILabel()
        label.text = "تایید کد ارسالی"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let codeLabel:UILabel = {
        var label = UILabel()
        label.text = " کد ۵ رقمی به شماره شما فرستاده شد."
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editNumber:UIButton = {
             var btn = UIButton()
              btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
              btn.backgroundColor = .clear
        btn.setTitle("اصلاح شماره ", for: .normal)
              btn.imageView?.contentMode = .scaleToFill
              btn.setTitleColor(.white, for: UIControlState.normal)
              btn.addTarget(self, action: #selector(hanldeExit), for: .touchUpInside)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = .easyBaziGreen
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 13)
        btn.titleLabel?.textColor = .white
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
              btn.translatesAutoresizingMaskIntoConstraints = false
              return btn
          }()
    
    let codeInput:UITextField = {
        var input = UITextField()
        input.textColor = .white
        input.font = UIFont(name: "IRANSans", size: 17)
        input.textAlignment = .center
        input.layer.borderWidth = 1
        input.autocorrectionType = .no
        input.layer.borderColor = UIColor.easyBaziTheme.cgColor
        input.layer.cornerRadius = 2
        input.placeholder = "محل وارد کردن کد"
        var attr = NSAttributedString(string: "محل وارد کردن کد", attributes: [NSAttributedStringKey.font  :UIFont(name: "IRANSans", size: 15)! , NSAttributedStringKey.foregroundColor  : UIColor.lightGray
               ])
        input.attributedPlaceholder = attr
        input.keyboardType = .asciiCapableNumberPad
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    
    @objc func hanldeExit(){
        navigationController?.popToRootViewController(animated: true)
       }
    
    
    
    let dividerView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.layer.cornerRadius = 5
       view.alpha = 0.45
        return view
    }()
  
    let submitButton:UIButton = {
       var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ارسال", for: .normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
        btn.titleLabel?.textColor = .white
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .easyBaziTheme
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return btn
    }()
    
    var font:UIFont!
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func handleSubmit(){
        //send mobile number & verification code to server and got token and move on to compelet registeration.
        //check if it's for signup or resset password
        if isForReckogning{
            SVProgressHUD.show(withStatus:"در حال انجام...")
            phoneNumber = getUserPhoneNumber()
            VerificationCode.codeVerify(mobileNumber: phoneNumber, verificationCode: codeInput.text!, completion: { (status,message,token) in
                if status == 1 {//server is ok
                    guard let token = token else{ return }
                    
                    SVProgressHUD.showSuccess(withStatus:message)
                    SVProgressHUD.dismiss(withDelay: 2)
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let reckogningVC = storyboard.instantiateViewController(withIdentifier: "reckogningVC") as? ReckogningViewController
                    reckogningVC?.token = token
                    self.codeInput.text = ""
                    self.navigationController?.pushViewController(reckogningVC!, animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 4)
                    print("mobile verification in reckogning Failed...")
                }
            })
            
        }else{
            
            if isForSignup {
                         if codeInput.text?.count == 0 {
                                    let alert = UIAlertController(title: "توجه !!!", message: "کد تایید ۵ رقمی می باشد.", preferredStyle: UIAlertControllerStyle.alert)
                                 alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                                 alert.setValue(NSAttributedString(string:  "کد تایید ۵ رقمی می باشد." , attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                                 alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
                                 alert.view.tintColor = UIColor.white
                                          self.present(alert, animated: true, completion: nil)
                             }else{
                                 
                                verificationCode = codeInput.text
                                SVProgressHUD.show(withStatus: "در حال انجام ... ")
                                SVProgressHUD.dismiss(withDelay: 1)
                                
                                VerificationCode.codeVerify(mobileNumber: phoneNumber, verificationCode: verificationCode!, completion: { (status,message,token) in
                                        if status == 1 {//server is ok
                                            guard let token = token else{ return }
                                            SVProgressHUD.showSuccess(withStatus:message)
                                            SVProgressHUD.dismiss(withDelay: 2)
                                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                            let signupDetailesVC = storyboard.instantiateViewController(withIdentifier: "signupDetailesVC") as? SignupDetailesViewController
                                            signupDetailesVC?.token = token
                                            signupDetailesVC?.mobileNumber = self.phoneNumber
                                            self.codeInput.text = ""
                                            self.navigationController?.pushViewController(signupDetailesVC!, animated: true)
                                        }else{
                                            SVProgressHUD.showError(withStatus: message)
                                            SVProgressHUD.dismiss(withDelay: 2)
                                            print("mobile verification in signup Failed...")
                                        }
                                    })
                               
                                }
                        
                        
                        
                    }else{//code verification for reset password
                        if codeInput.text?.count == 0 {
                            let alert = UIAlertController(title: "توجه !!!", message: "کد تایید ۵ رقمی می باشد.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                            alert.setValue(NSAttributedString(string:  "کد تایید ۵ رقمی می باشد." , attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                            alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
                            alert.view.tintColor = UIColor.white
                                       self.present(alert, animated: true, completion: nil)
                          }else{
                            verificationCode = codeInput.text
                            VerificationCode.codeVerify(mobileNumber: phoneNumber, verificationCode: verificationCode!) { (status, message, token) in
                                if status == 1{
                                    guard let token = token else{ return }
                                    SVProgressHUD.showSuccess(withStatus:message)
                                    SVProgressHUD.dismiss(withDelay: 2)
                                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                    let newPasswordVC = storyboard.instantiateViewController(withIdentifier: "newPasswordVC") as? NewPasswordViewController
                                    self.codeInput.text = ""
                                    newPasswordVC?.token = token
                                    newPasswordVC?.mobileNumber = self.phoneNumber
                                    self.navigationController?.pushViewController(newPasswordVC!, animated: true)
                                }else{
                                    
                                }
                            }
                        }
                    }
                }
        }
    
    let codeNotReceivedLabel:UILabel = {
           var label = UILabel()
           label.text = "کدی دریافت نکرده اید ؟"
           label.textColor = .lightGray
           label.font = UIFont(name: "IRANSans", size: 12)
           label.textAlignment = .right
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let sendCodeAgainLabel:UILabel = {
           var label = UILabel()
           label.text = "ارسال مجدد کد"
           label.textColor = .lightGray
           label.font = UIFont(name: "IRANSans", size: 12)
           label.textAlignment = .left
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let labelStack:UIStackView = {
            var stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.backgroundColor = .clear
            stack.distribution = .fillProportionally
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        font = UIFont(name: "IRANSans", size: 13)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        title = "تایید شماره همراه"
//        hidesBottomBarWhenPushed = true
        codeInput.delegate = self
        setupExitButton()
        setupSubmitButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
            // Do any additional setup after loading the view.
        codeInput.becomeFirstResponder()
        if isForReckogning{
            editNumber.isHidden = true
        }
        setupTimer()
        
        }
        @objc func endEditing(){
            view.endEditing(true)
        }
    
      fileprivate func setupSubmitButton() {
          view.backgroundColor = .backgroundThem
          view.addSubview(submitButton)
          submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
          submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
         submitButton.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: 16).isActive = true
          submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
      }
    
    fileprivate func setupExitButton() {
//        view.addSubview(exit)
//         view.addSubview(renewalDetailesLabel)
//        view.addSubview(dividerView)
//        exit.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
//        exit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        ex/it.widthAnchor.constraint(equalToConstant: view.frame.size.width/15).isActive = true
//        exit.heightAnchor.constraint(equalToConstant: view.frame.size.width/15).isActive = true
//        renewalDetailesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
//        renewalDetailesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        dividerView.topAnchor.constraint(equalTo: exit.bottomAnchor, constant: 8).isActive = true
//        dividerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        dividerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        view.addSubview(codeLabel)
        codeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(editNumber)
        editNumber.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 16).isActive = true
        editNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editNumber.setTitle("اصلاح شماره  \(convertToPersian(inputStr: phoneNumber))", for: .normal)
        editNumber.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        editNumber.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        
        view.addSubview(codeInput)
        codeInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        codeInput.topAnchor.constraint(equalTo: editNumber.bottomAnchor, constant: 32).isActive = true
        codeInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        codeInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        labelStack.addArrangedSubview(sendCodeAgainLabel)
        labelStack.addArrangedSubview(codeNotReceivedLabel)
        view.addSubview(labelStack)
        labelStack.topAnchor.constraint(equalTo: codeInput.bottomAnchor, constant:  32).isActive = true
        labelStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        labelStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
    }
    
    
    
   //Helper methods
    
    @objc func keyboardWillShown(notification: NSNotification) {
          
      }
    var bottomConstraint:NSLayoutConstraint!
      @objc func keyboardWillHidden(notification: NSNotification) {
      }
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    
    func eraseToken(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                context.delete(data)
                try context.save()
            }
            print("Erasing Seccessfully")
        }catch{
            print("Erasing Error")
        }
    }
    //timer staff here
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }

    @objc func onTimerFires() {
        timeLeft -= 1
        sendCodeAgainLabel.text = "\(convertToPersian(inputStr: "\(timeLeft)")) ثانیه تا ارسال مجدد کد"

        if timeLeft <= 0 {//change label title and add gesture recognizer to label
            sendCodeAgainLabel.isUserInteractionEnabled = true
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            sendCodeAgainLabel.addGestureRecognizer(tapGesture)
            timeLeft = 60
            sendCodeAgainLabel.textColor = .white
            sendCodeAgainLabel.text = "ارسال مجدد کد"
            timer?.invalidate()
            timer = nil
        }
    }
     //check code character count
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           var temp:Bool = false
           if textField == codeInput{
               let maxLength = 5
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               temp = newString.length <= maxLength
           }
           return temp
       }
    
    @objc func handleTap(){
        
        getVerificationCode()
        
    }
    
    func getUserPhoneNumber()->String{
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
            request.returnsObjectsAsFaults = false
            var userPhoneNumber = ""
            do{
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject]{
               
                    userPhoneNumber = data.value(forKey: "userPhoneNumber") as! String
                }
                print("Fetching Seccessfully")
            }catch{
                print("Fetching Error")
                
            }
            return userPhoneNumber
        }
    
     @objc func getVerificationCode(){
                    SVProgressHUD.setDefaultMaskType(.gradient)
                    SVProgressHUD.show(withStatus: "در حال ارسال کد فعالسازی... ")
        
        if isForReckogning{
            VerificationCode.sendForReckogning(getToken()) { (status, message) in
                if status == 1{
                    SVProgressHUD.show(withStatus:message)
                    SVProgressHUD.dismiss(withDelay: 3)
                    self.sendCodeAgainLabel.removeGestureRecognizer(self.tapGesture)
                    self.setupTimer()
                    
                }else{
                    SVProgressHUD.show(withStatus:message )
                    SVProgressHUD.dismiss(withDelay: 3)
                }
            }
            
            
        }else{
            if isForSignup == true{
                VerificationCode.sendForSignup(phoneNumber) { (status, message) in
                                    if status == 1{
                                       SVProgressHUD.show(withStatus:message)
                                       SVProgressHUD.dismiss(withDelay: 3)
                                       self.sendCodeAgainLabel.removeGestureRecognizer(self.tapGesture)
                                       self.setupTimer()
                                    }else{
                                        SVProgressHUD.show(withStatus:message )
                                        SVProgressHUD.dismiss(withDelay: 3)
                                    }
                            }
            }else{
                VerificationCode.sendForResetPassword(phoneNumber) { (status, message) in
                                    if status == 1{
                                       SVProgressHUD.show(withStatus:message)
                                       SVProgressHUD.dismiss(withDelay: 3)
                                       self.sendCodeAgainLabel.removeGestureRecognizer(self.tapGesture)
                                       self.setupTimer()
                                    }else{
                                        SVProgressHUD.show(withStatus:message )
                                        SVProgressHUD.dismiss(withDelay: 3)
                                    }
                            }
            }
            
        }
    }
}

