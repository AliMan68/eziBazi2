//
//  NewPasswordViewController.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/4/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
     
        var token : String!
        
        var mobileNumber : String!
            
        var contentFont:UIFont!
  
        var font:UIFont!
           
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
            let firstView:UIView = {
                var view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor.clear
                view.layer.cornerRadius = 5
                return view
            }()

            let passwordInput:UITextField = {
                var label = UITextField()
                label.textColor = .white
                label.placeholder = ""
                label.autocorrectionType = .no
    //            label.backgroundColor = .red
                label.font = UIFont(name: "IRANSans", size:13)
                label.textAlignment = .right
                label.textColor = .white
                label.layer.borderColor? = UIColor.lightGray.cgColor
                label.layer.borderWidth = 0.5
                label.autocorrectionType = .no
                label.layer.cornerRadius = 3
                label.isSecureTextEntry = true
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let pleaseAddNewPasswordLabel:UILabel = {
                  var label = UILabel()
                  label.text = "لطفا رمز جدید خود را در کادر زیر وارد نمایید."
                  label.textColor = .white
                  label.font = UIFont(name: "IRANSans", size: 14)
                  label.textAlignment = .center
                  label.translatesAutoresizingMaskIntoConstraints = false
                  return label
              }()

            let registerButton : UIButton = {
                var btn = UIButton()
                btn.setTitle("ثبت رمز", for: UIControlState.normal)
                btn.titleLabel?.font = UIFont(name: "IRANSans", size:14)
                btn.titleLabel?.textColor = .red
                btn.backgroundColor = UIColor.easyBaziGreen
                btn.titleLabel?.textAlignment = .center
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.layer.cornerRadius = 5
                btn.layer.borderColor = UIColor.backgroundThem.cgColor
                btn.layer.borderWidth = 0.5
                btn.addTarget(self, action: #selector(handleNewPassword), for: UIControlEvents.touchDown)
                return btn
            }()
            fileprivate func setupFirstViewContent() {

                firstView.addSubview(passwordInput)
                passwordInputSetup()
                
            }
        
        var registerButtonConstraint:NSLayoutConstraint!
        override func viewDidLoad() {
                super.viewDidLoad()
            font = UIFont(name: "IRANSans", size: 13)
                title = "ثبت رمز جدید "
                view.backgroundColor = UIColor.backgroundThem
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
                
                setupFirstView()
                setupFirstViewContent()
                setupRegisterButton()
                containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
                passwordInput.becomeFirstResponder()
        }
        
        fileprivate func setupRegisterButton(){
            containerView.addSubview(registerButton)
            registerButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
            registerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
            registerButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 16).isActive = true
            
            registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        
        @objc func endEditing(){
            view.endEditing(true)
        }

          @objc func handlePeriodChanges(_sender:UISegmentedControl){

            }
            
            @objc func handleNewPassword(){//connect to server later,here                
                if passwordInput.text!.count < 6{
                    let alert = UIAlertController(title: "توجه !!!", message: "رمز عبور باید حداقل ۶ حرفی باشد.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                        alert.setValue(NSAttributedString(string:  "رمز عبور باید حداقل ۶ حرفی باشد." , attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                        alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
                        alert.view.tintColor = UIColor.white
                                                 self.present(alert, animated: true, completion: nil)
                }else{
                    SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 12)!)
                    
                    SVProgressHUD.show(withStatus: "در حال انجام ...")
//                    SVProgressHUD.dismiss(withDelay: 2)
                    ResetPassword.setNewPassword(password: passwordInput.text!, token: token, mobileNumber: mobileNumber) { (status, message) in
                        if status == 1 {
                            SVProgressHUD.showSuccess(withStatus: message)
                            SVProgressHUD.dismiss(withDelay: 3)
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            SVProgressHUD.showError(withStatus: message)
                            SVProgressHUD.dismiss(withDelay: 4)
                            self.view.endEditing(true)
                        }
                    }
                    
                }
               
            }
            
            fileprivate func passwordInputSetup(){
                   passwordInput.topAnchor.constraint(equalTo: pleaseAddNewPasswordLabel.bottomAnchor, constant: 16).isActive = true
                   passwordInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 16).isActive = true
                   passwordInput.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -16).isActive = true
                   passwordInput.heightAnchor.constraint(equalToConstant:45).isActive = true
                
               }
            
         
            
             fileprivate func setupFirstView(){
                    containerView.addSubview(pleaseAddNewPasswordLabel)
                    containerView.addSubview(firstView)
                    pleaseAddNewPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
                    pleaseAddNewPasswordLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
                    let top = firstView.topAnchor.constraint(equalTo: pleaseAddNewPasswordLabel.bottomAnchor, constant: 8)
                    let right = firstView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
                    let left = firstView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
                    let contentSize = CGSize(width: containerView.frame.width, height: 1000)
                    contentFont = UIFont(name: "IRANSans", size: 13)
                    let contentEstimatedFrame = NSString(string: pleaseAddNewPasswordLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
                    firstView.heightAnchor.constraint(equalToConstant: (contentEstimatedFrame.height * 5) + 80).isActive = true
                    NSLayoutConstraint.activate([top,right,left])
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
        }
