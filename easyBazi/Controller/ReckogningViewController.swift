//
//  ReckogningViewController.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/7/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import UIKit
import SVProgressHUD
import CoreData
class ReckogningViewController: UIViewController,UITextFieldDelegate {
    

        @IBOutlet weak var scrollView: UIScrollView!
        
        @IBOutlet weak var containerView: UIView!
    
    var token : String!
        
    var contentFont:UIFont!
    
    var margin:CGFloat = 8.0
    
    var font:UIFont!
    
    var reckoningViewContainer:ReckoningView!
       
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
            name.text = " نام و نام خانوادگی  :"
            name.translatesAutoresizingMaskIntoConstraints = false
            name.font = UIFont(name: "IRANSans",size: 13)
            name.textColor = .lightGray
            name.textAlignment = .right
            return name
        }()
        private var previousTextFieldContent: String?
        private var previousSelection: UITextRange?
    
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
        
        let accountNumberLabel:UILabel = {
              var name = UILabel()
               name.text = " شماره حساب : "
               name.translatesAutoresizingMaskIntoConstraints = false
               name.font = UIFont(name: "IRANSans",size: 13)
               name.textColor = .lightGray
               name.textAlignment = .right
               return name
           }()
        let cardNumberLabel:UILabel = {
              var name = UILabel()
               name.text = " شماره کارت : "
               name.translatesAutoresizingMaskIntoConstraints = false
               name.font = UIFont(name: "IRANSans",size: 13)
               name.textColor = .lightGray
               name.textAlignment = .right
               return name
           }()
         let shbaNumberLabel:UILabel = {
            var name = UILabel()
             name.text = "شماره شبا : "
             name.translatesAutoresizingMaskIntoConstraints = false
             name.font = UIFont(name: "IRANSans",size: 13)
             name.textColor = .lightGray
             name.textAlignment = .right
             return name
         }()
        let accountNumberInput:UITextField = {
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
         let cardNumberInput:UITextField = {
               var label = UITextField()
            label.autocorrectionType = .no
                          label.textColor = .white
                          label.placeholder = ""
              //            label.backgroundColor = .red
                          label.font = UIFont(name: "IRANSans", size:13)
                          label.textAlignment = .center
                          label.textColor = .white
                          label.layer.borderColor? = UIColor.lightGray.cgColor
                          label.layer.borderWidth = 0.5
                          label.layer.cornerRadius = 3
            label.keyboardType = .asciiCapableNumberPad
                          label.translatesAutoresizingMaskIntoConstraints = false
                          return label
           }()
        let shbaNumberInput:UITextField = {
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
        let settlementLabel:UILabel = {
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
              label.text = "اطلاعات بانکی"
              label.textColor = .white
              label.font = UIFont(name: "IRANSans", size: 14)
              label.textAlignment = .right
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
          }()
        let registerButton : UIButton = {
            var btn = UIButton()
            btn.setTitle("ثبت درخواست", for: UIControlState.normal)
            btn.titleLabel?.font = UIFont(name: "IRANSans", size:14)
            btn.titleLabel?.textColor = .red
            btn.backgroundColor = UIColor.easyBaziGreen
            btn.titleLabel?.textAlignment = .center
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.layer.cornerRadius = 5
            btn.layer.borderColor = UIColor.backgroundThem.cgColor
            btn.layer.borderWidth = 0.5
            btn.addTarget(self, action: #selector(handlReckogningRequest), for: UIControlEvents.touchDown)
            return btn
        }()
        fileprivate func setupFirstViewContent() {
            firstView.addSubview(fullNamelabel)
            fullNameLabelSetup()
            firstView.addSubview(accountNumberLabel)
            nationalCodeLabelSetup()
            firstView.addSubview(cardNumberLabel)
            emailLabelSetup()
            firstView.addSubview(shbaNumberLabel)
            passwordLabelSetup()
            
            firstView.addSubview(fullNameInput)
            fullNameInputSetup()
            firstView.addSubview(accountNumberInput)
            nationalCodeInputSetup()
            firstView.addSubview(cardNumberInput)
            emailInputSetup()
            firstView.addSubview(shbaNumberInput)
            passwordInputSetup()
           
        }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var registerButtonConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
            super.viewDidLoad()
            font = UIFont(name: "IRANSans", size: 13)
        cardNumberInput.delegate = self
        reckoningViewContainer = ReckoningView()
        reckoningViewContainer.reckogningVC = self
        reckoningViewContainer.show()
            title = "درخواست تسویه حساب "
            view.backgroundColor = UIColor.backgroundThem
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
            setupFirstView()
            setupFirstViewContent()
            setupRegisterButton()
            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
            
    }
    
    fileprivate func setupRegisterButton(){
        containerView.addSubview(registerButton)
        registerButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        registerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        registerButton.topAnchor.constraint(equalTo: dividerView7.bottomAnchor, constant: 16).isActive = true
        
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }

      @objc func handlePeriodChanges(_sender:UISegmentedControl){

        }
        
        @objc func handlReckogningRequest(){//connect to server later,here
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 13)!)
            SVProgressHUD.show(withStatus: "در حال انجام ...")
            Reckogning.request(accountOwner: fullNameInput.text!, cardNumber: cardNumberInput.text!, accountNumber: accountNumberInput.text!, shbaNumber: shbaNumberInput.text!, vToken: token, mobileNumber: getUserPhoneNumber(), token: getToken()) { (status, message) in
                if status == 1{
                    SVProgressHUD.showSuccess(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 2)
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    SVProgressHUD.showSuccess(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 2)
                    self.navigationController?.popToRootViewController(animated: true)
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
        
            accountNumberLabel.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
            accountNumberLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView3)
            dividerView3.topAnchor.constraint(equalTo: accountNumberLabel.bottomAnchor, constant: 8).isActive = true
            dividerView3.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            dividerView3.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            dividerView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
     
        }
        fileprivate func emailLabelSetup(){
            
            cardNumberLabel.topAnchor.constraint(equalTo: accountNumberLabel.bottomAnchor, constant: 16).isActive = true
            cardNumberLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView4)
            dividerView4.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 8).isActive = true
            dividerView4.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            dividerView4.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            dividerView4.heightAnchor.constraint(equalToConstant: 1).isActive = true

        }
    
        fileprivate func passwordLabelSetup(){
        
            shbaNumberLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 16).isActive = true
            shbaNumberLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
            
            firstView.addSubview(dividerView7)
            dividerView7.topAnchor.constraint(equalTo: shbaNumberLabel.bottomAnchor, constant: 8).isActive = true
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
               
            
           }
        
        fileprivate func nationalCodeInputSetup(){
             
             accountNumberInput.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
             accountNumberInput.bottomAnchor.constraint(equalTo: dividerView3.topAnchor, constant: -8).isActive = true
             accountNumberInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
             accountNumberInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
            accountNumberInput.heightAnchor.constraint(equalToConstant:fullNamelabel.intrinsicContentSize.height + 16 ).isActive = true
            let rightView = UIView(frame: CGRect(
                x: 0, y: 0, // keep this as 0, 0
                width: 2 * margin, // add the padding
                height: margin))
                accountNumberInput.leftViewMode = .always
                accountNumberInput.leftView = rightView
                            
             
             
          }
          fileprivate func emailInputSetup(){
            
            cardNumberInput.topAnchor.constraint(equalTo: dividerView3.bottomAnchor, constant: 8).isActive = true
            cardNumberInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
            cardNumberInput.bottomAnchor.constraint(equalTo: dividerView4.topAnchor, constant: -8).isActive = true
            cardNumberInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
            cardNumberInput.heightAnchor.constraint(equalToConstant:cardNumberInput.intrinsicContentSize.height + 8 ).isActive = true
           
            cardNumberInput.heightAnchor.constraint(equalToConstant:fullNamelabel.intrinsicContentSize.height + margin ).isActive = true
            
            let attributes = [
                       NSAttributedStringKey.foregroundColor: UIColor.gray,
                       NSAttributedStringKey.font : font
                   ]
            cardNumberInput.textAlignment = .center
            cardNumberInput.attributedPlaceholder = NSAttributedString(string: "XXXX - XXXX - XXXX - XXXX", attributes: attributes as [NSAttributedStringKey : Any])
              
          }
        
        fileprivate func passwordInputSetup(){
          
          shbaNumberInput.topAnchor.constraint(equalTo: dividerView4.bottomAnchor, constant: 8).isActive = true
          shbaNumberInput.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
          shbaNumberInput.widthAnchor.constraint(equalToConstant: containerView.frame.size.width - (10 * margin + fullNamelabel.intrinsicContentSize.width)).isActive = true
            
          shbaNumberInput.heightAnchor.constraint(equalToConstant:shbaNumberInput.intrinsicContentSize.height + 16 ).isActive = true
          shbaNumberInput.bottomAnchor.constraint(equalTo: dividerView7.topAnchor, constant: -8).isActive = true
          let rightView = UIView(frame: CGRect(
                     x: 0, y: 0, // keep this as 0, 0
                     width: 2 * margin, // add the padding
                     height: margin))
            let leftView = UIView(frame: CGRect(
            x: 0, y: 0, // keep this as 0, 0
            width: 2 * margin, // add the padding
            height: margin))
        shbaNumberInput.leftViewMode = .always
            let label = UILabel()
            label.textColor = .gray
            label.textAlignment = .left
            label.text = "IR"
            label.font = UIFont.systemFont(ofSize: 14)
            leftView.addSubview(label)
            label.frame = leftView.bounds
            
        shbaNumberInput.leftView = rightView
        shbaNumberInput.rightView = leftView
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
    
    
    func getToken()->String{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        var token = ""
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
           
                token = data.value(forKey: "token") as! String
            }
            print("Fetching Seccessfully")
        }catch{
            print("Fetching Error")
            
        }
        return token
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

