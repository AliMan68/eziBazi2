//
//  SignupDetailesViewController.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 2/2/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData
import SafariServices
class SignupDetailesViewController: UIViewController {
    

        @IBOutlet weak var scrollView: UIScrollView!
        
        @IBOutlet weak var containerView: UIView!
    
    var token : String!
    
    var mobileNumber : String!
        
    var contentFont:UIFont!
    
    var margin:CGFloat = 8.0
    
    var font:UIFont!
       
        let firstView:UIView = {
            var view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.clear
            view.layer.cornerRadius = 5
            return view
        }()
        
        let dividerView2:UIView = {
              var view = UIView()
              view.translatesAutoresizingMaskIntoConstraints = false
              view.backgroundColor = UIColor.easyBaziTheme
              view.layer.cornerRadius = 5
              view.alpha = 0.45
              return view
          }()
        let dividerView3:UIView = {
                var view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor.easyBaziTheme
                view.layer.cornerRadius = 5
                view.alpha = 0.45
                return view
            }()
        let dividerView4:UIView = {
                 var view = UIView()
                 view.translatesAutoresizingMaskIntoConstraints = false
                 view.backgroundColor = UIColor.easyBaziTheme
                 view.layer.cornerRadius = 5
                 view.alpha = 0.45
                 return view
             }()
        let dividerView5:UIView = {
                  var view = UIView()
                  view.translatesAutoresizingMaskIntoConstraints = false
                  view.backgroundColor = UIColor.easyBaziTheme
                  view.layer.cornerRadius = 5
                  view.alpha = 0.45
                  return view
              }()
        let dividerView6:UIView = {
                  var view = UIView()
                  view.translatesAutoresizingMaskIntoConstraints = false
                  view.backgroundColor = UIColor.easyBaziTheme
                  view.layer.cornerRadius = 5
                  view.alpha = 0.45
                  return view
              }()
        let dividerView7:UIView = {
            var view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.easyBaziTheme
            view.layer.cornerRadius = 5
            view.alpha = 0.45
            return view
        }()
        
        let secondView:UIView = {
             var view = UIView()
             view.translatesAutoresizingMaskIntoConstraints = false
             view.backgroundColor = UIColor.clear
             view.layer.cornerRadius = 5
             return view
         }()
        
        let fullNamelabel:UILabel = {
           var name = UILabel()
            name.text = " نام و نام خانوادگی :"
            name.translatesAutoresizingMaskIntoConstraints = false
            name.font = UIFont(name: "IRANSans",size: 13)
            name.textColor = .lightGray
            name.textAlignment = .right
            return name
        }()
        
        let renewalPeriodLabel:UILabel = {
              var name = UILabel()
               name.text = " بازه(روز) : "
               name.translatesAutoresizingMaskIntoConstraints = false
               name.font = UIFont(name: "IRANSans",size: 13)
               name.textColor = .lightGray
               name.textAlignment = .right
               return name
           }()
        let renewalPriceLabel:UILabel = {
                 var name = UILabel()
                  name.text = "قیمت :"
                  name.translatesAutoresizingMaskIntoConstraints = false
                  name.font = UIFont(name: "IRANSans",size: 13)
                  name.textColor = .lightGray
                  name.textAlignment = .right
                  return name
              }()
        let renewalPrice:UILabel = {
                   var name = UILabel()
                    name.text = "۹۹۹ هزار تومان"
                    name.translatesAutoresizingMaskIntoConstraints = false
                    name.font = UIFont(name: "IRANSans",size: 13)
                    name.textColor = .white
                    name.textAlignment = .left
                    return name
                }()
        
        let renewalPeriods:UISegmentedControl = {
                   var segment = UISegmentedControl()
                   segment.insertSegment(withTitle: "۷", at: 0, animated: true)
                   segment.insertSegment(withTitle:  "۱۰", at: 1, animated: true)
                   segment.insertSegment(withTitle: "۱۵", at: 2, animated: true)
                   segment.translatesAutoresizingMaskIntoConstraints = false
                   segment.tintColor = .easyBaziTheme
                   segment.selectedSegmentIndex = 1
                   if #available(iOS 13.0, *) {
                             segment.selectedSegmentTintColor = UIColor.easyBaziTheme
                         }
                   let attr:[AnyHashable:Any] = [NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.white]
                   segment.tintColor = .white
                   segment.setTitleTextAttributes(attr, for: UIControlState.normal)
                   segment.layer.borderWidth = 0.5
                   segment.layer.borderColor = UIColor.backgroundThem.cgColor
            segment.addTarget(self, action: #selector(handlePeriodChanges(_sender:)), for: UIControlEvents.valueChanged)
                   return segment
               }()
        
        let nationalCodeLabel:UILabel = {
              var name = UILabel()
               name.text = " کد ملی : "
               name.translatesAutoresizingMaskIntoConstraints = false
               name.font = UIFont(name: "IRANSans",size: 13)
               name.textColor = .lightGray
               name.textAlignment = .right
               return name
           }()
        let emailLabel:UILabel = {
              var name = UILabel()
               name.text = " ایمیل : "
               name.translatesAutoresizingMaskIntoConstraints = false
               name.font = UIFont(name: "IRANSans",size: 13)
               name.textColor = .lightGray
               name.textAlignment = .right
               return name
           }()
         let passwordLabel:UILabel = {
            var name = UILabel()
             name.text = " رمز عبور : "
             name.translatesAutoresizingMaskIntoConstraints = false
             name.font = UIFont(name: "IRANSans",size: 13)
             name.textColor = .lightGray
             name.textAlignment = .right
             return name
         }()
        let nationalCodeInput:UITextField = {
               var label = UITextField()
            label.autocorrectionType = .no
                         label.textColor = .white
                         label.placeholder = ""
             //            label.backgroundColor = .red
                         label.font = UIFont(name: "IRANSans", size:13)
                         label.textAlignment = .right
                         label.textColor = .white
                         label.layer.borderColor? = UIColor.lightGray.cgColor
                         label.layer.borderWidth = 0.5
                         label.layer.cornerRadius = 3
            label.keyboardType = .asciiCapableNumberPad
                         label.translatesAutoresizingMaskIntoConstraints = false
                         return label
         }()
         let emailInput:UITextField = {
               var label = UITextField()
            label.autocorrectionType = .no
                          label.textColor = .white
                          label.placeholder = ""
              //            label.backgroundColor = .red
                          label.font = UIFont(name: "IRANSans", size:13)
                          label.textAlignment = .right
                          label.textColor = .white
                          label.layer.borderColor? = UIColor.lightGray.cgColor
                          label.layer.borderWidth = 0.5
                          label.layer.cornerRadius = 3
            label.keyboardType = .emailAddress
                          label.translatesAutoresizingMaskIntoConstraints = false
                          return label
           }()
        let passwordInput:UITextField = {
                var label = UITextField()
                label.textColor = .white
    
                label.placeholder = ""
                label.font = UIFont(name: "IRANSans", size:13)
                label.textAlignment = .right
                label.textColor = .white
                label.layer.borderColor? = UIColor.lightGray.cgColor
                label.layer.borderWidth = 0.5
                label.layer.cornerRadius = 3
                label.isSecureTextEntry = true
                label.translatesAutoresizingMaskIntoConstraints = false
                label.autocorrectionType = .no
                return label
              }()
        let completeRegisterLabel:UILabel = {
              var label = UILabel()
              label.text = "تکمیل ثبت نام "
              label.textColor = .white
              label.font = UIFont(name: "IRANSans", size: 16)
              label.textAlignment = .right
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
          }()
        let fullNameInput:UITextField = {
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
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let personalInfo:UILabel = {
              var label = UILabel()
              label.text = "مشخصات فردی"
              label.textColor = .white
              label.font = UIFont(name: "IRANSans", size: 14)
              label.textAlignment = .right
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
          }()
        let bottomStack:UIStackView = {
              var stack = UIStackView()
              stack.axis = .horizontal
              stack.spacing = 8
              stack.backgroundColor = .red
              stack.distribution = .fillEqually
              stack.translatesAutoresizingMaskIntoConstraints = false
              return stack
          }()
        let registerButton : UIButton = {
            var btn = UIButton()
            btn.setTitle("ثبت اطلاعات", for: UIControlState.normal)
            btn.titleLabel?.font = UIFont(name: "IRANSans", size:14)
            btn.titleLabel?.textColor = .red
            btn.backgroundColor = UIColor.easyBaziGreen
            btn.titleLabel?.textAlignment = .center
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.layer.cornerRadius = 5
            btn.layer.borderColor = UIColor.backgroundThem.cgColor
            btn.layer.borderWidth = 0.5
            btn.addTarget(self, action: #selector(handleSignup), for: UIControlEvents.touchDown)
            return btn
        }()
    let termsButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("با تکمیل این فرم با قوانین و شرایط ایزی بازی موافقت می کنید.", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:10)
    
        btn.setTitleColor(.gray, for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleTermsButton), for: UIControlEvents.touchUpInside)
        return btn
    }()
    @objc func handleTermsButton(){
        let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/terms")!)
        self.present(safariVC, animated: true, completion: nil)
    }
    
        fileprivate func setupFirstViewContent() {
            firstView.addSubview(fullNamelabel)
            fullNameLabelSetup()
            firstView.addSubview(nationalCodeLabel)
            nationalCodeLabelSetup()
            firstView.addSubview(emailLabel)
            emailLabelSetup()
            firstView.addSubview(passwordLabel)
            passwordLabelSetup()
            
            firstView.addSubview(fullNameInput)
            fullNameInputSetup()
            firstView.addSubview(nationalCodeInput)
            nationalCodeInputSetup()
            firstView.addSubview(emailInput)
            emailInputSetup()
            firstView.addSubview(passwordInput)
            passwordInputSetup()
           
        }
    
    var registerButtonConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
            super.viewDidLoad()
        font = UIFont(name: "IRANSans", size: 13)
            title = "تکمیل ثبت نام "
            view.backgroundColor = UIColor.backgroundThem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
            
            setupFirstView()
            setupFirstViewContent()
            setupRegisterButton()
            setupTermsButton()
            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
            fullNameInput.becomeFirstResponder()
    }
    
    fileprivate func setupTermsButton(){
        
        containerView.addSubview(termsButton)
        termsButton.leftAnchor.constraint(equalTo: registerButton.leftAnchor, constant: 4).isActive = true
        termsButton.rightAnchor.constraint(equalTo: registerButton.rightAnchor, constant: -4).isActive = true
        termsButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 8).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    fileprivate func setupRegisterButton(){
        containerView.addSubview(registerButton)
        registerButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        registerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        registerButton.topAnchor.constraint(equalTo: dividerView7.bottomAnchor, constant: 16).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }

    @objc func handlePeriodChanges(_sender:UISegmentedControl){

        }
        
        @objc func handleSignup(){//connect to server later,here
            
            SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 13)!)
            SVProgressHUD.show(withStatus: "در حال انجام ...")
            SignUP.complete(fullName: fullNameInput.text!, email: emailInput.text!, nationalCode: nationalCodeInput.text!, mobileNumber: mobileNumber, password: passwordInput.text!, token: token) { (status, message, data) in
                 let attributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : self.font])
                if status == 1{
                    guard let data = data else{
                        return
                    }
                    SVProgressHUD.showSuccess(withStatus:attributedString.string)
                    SVProgressHUD.dismiss(withDelay: 3)
                    self.eraseToken()                       
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "TokenEntity", in:context)
                    let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                    newEntity.setValue(data.token, forKey: "token")
                    newEntity.setValue(data.user.full_name, forKey: "userName")
                    newEntity.setValue(data.user.mobile, forKey: "userPhoneNumber")
                    do{
                        try context.save()
                    }catch{
                        print("Error While Saving Token")
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLogout"), object: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                        SVProgressHUD.showError(withStatus:attributedString.string)
                        SVProgressHUD.dismiss(withDelay: 3)
                   
                }
            }
        }
        
        
        fileprivate func fullNameLabelSetup(){
            fullNamelabel.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 8).isActive = true
            fullNamelabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView2)
            dividerView2.topAnchor.constraint(equalTo: fullNamelabel.bottomAnchor, constant: 8).isActive = true
            dividerView2.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            dividerView2.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            dividerView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        fileprivate func nationalCodeLabelSetup(){
        
            nationalCodeLabel.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
            nationalCodeLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView3)
            dividerView3.topAnchor.constraint(equalTo: nationalCodeLabel.bottomAnchor, constant: 8).isActive = true
            dividerView3.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            dividerView3.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            dividerView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
     
        }
        fileprivate func emailLabelSetup(){
            
            emailLabel.topAnchor.constraint(equalTo: nationalCodeLabel.bottomAnchor, constant: 16).isActive = true
            emailLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView4)
            dividerView4.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8).isActive = true
            dividerView4.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            dividerView4.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            dividerView4.heightAnchor.constraint(equalToConstant: 1).isActive = true

        }
    
        fileprivate func passwordLabelSetup(){
        
            passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16).isActive = true
            passwordLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView7)
            dividerView7.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8).isActive = true
            dividerView7.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            dividerView7.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            dividerView7.heightAnchor.constraint(equalToConstant: 1).isActive = true

        }
        
        fileprivate func fullNameInputSetup(){
               
               fullNameInput.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 8).isActive = true
               fullNameInput.bottomAnchor.constraint(equalTo: dividerView2.topAnchor, constant: -8).isActive = true
               fullNameInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
//               fullNameInput.rightAnchor.constraint(equalTo: fullNamelabel.leftAnchor, constant: -4).isActive = true
              
               fullNameInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
               fullNameInput.heightAnchor.constraint(equalToConstant:fullNamelabel.intrinsicContentSize.height + 16 ).isActive = true
                let rightView = UIView(frame: CGRect(
                    x: 0, y: 0, // keep this as 0, 0
                    width: 2 * margin, // add the padding
                    height: margin))
                    fullNameInput.leftViewMode = .always
                    fullNameInput.leftView = rightView
            
           }
        
        fileprivate func nationalCodeInputSetup(){
             
             nationalCodeInput.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
             nationalCodeInput.bottomAnchor.constraint(equalTo: dividerView3.topAnchor, constant: -8).isActive = true
             nationalCodeInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
             nationalCodeInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
            nationalCodeInput.heightAnchor.constraint(equalToConstant:fullNamelabel.intrinsicContentSize.height + 16 ).isActive = true
            let rightView = UIView(frame: CGRect(
                x: 0, y: 0, // keep this as 0, 0
                width: 2 * margin, // add the padding
                height: margin))
                nationalCodeInput.leftViewMode = .always
                nationalCodeInput.leftView = rightView
                            
             
             
          }
          fileprivate func emailInputSetup(){
            
            emailInput.topAnchor.constraint(equalTo: dividerView3.bottomAnchor, constant: 8).isActive = true
            emailInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            emailInput.bottomAnchor.constraint(equalTo: dividerView4.topAnchor, constant: -8).isActive = true
            emailInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
            emailInput.heightAnchor.constraint(equalToConstant:emailInput.intrinsicContentSize.height + 8 ).isActive = true
            let rightView = UIView(frame: CGRect(
            x: 0, y: 0, // keep this as 0, 0
            width: 2 * margin, // add the padding
            height: margin))
            emailInput.leftViewMode = .always
            emailInput.leftView = rightView
            emailInput.heightAnchor.constraint(equalToConstant:fullNamelabel.intrinsicContentSize.height + margin ).isActive = true
            
              
          }
        
        fileprivate func passwordInputSetup(){
          
          passwordInput.topAnchor.constraint(equalTo: dividerView4.bottomAnchor, constant: 8).isActive = true
          passwordInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
          passwordInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
            
          passwordInput.heightAnchor.constraint(equalToConstant:passwordInput.intrinsicContentSize.height + 16 ).isActive = true
          passwordInput.bottomAnchor.constraint(equalTo: dividerView7.topAnchor, constant: -8).isActive = true
 
        }
        
         fileprivate func setupFirstView(){
                containerView.addSubview(personalInfo)
                containerView.addSubview(firstView)
                personalInfo.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
                personalInfo.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
                let top = firstView.topAnchor.constraint(equalTo: personalInfo.bottomAnchor, constant: 8)
                let right = firstView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
                let left = firstView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
                let contentSize = CGSize(width: containerView.frame.width, height: 1000)
                contentFont = UIFont(name: "IRANSans", size: 13)
                let contentEstimatedFrame = NSString(string: fullNamelabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
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
