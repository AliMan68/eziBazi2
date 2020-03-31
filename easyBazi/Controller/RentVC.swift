//
//  shopVC.swift
//  EziBazi2
//
//  Created by AliArabgary on 12/2/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import SafariServices
import SVProgressHUD

class RentVC: UIViewController , UITextViewDelegate,SFSafariViewControllerDelegate,UITextFieldDelegate{
//   lazy var scrollView:UIScrollView = {
//        var sv = UIScrollView()
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.backgroundColor = UIColor.blue
//        return sv
//    }()
//    let containerView:UIView = {
//       var view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.brown
//        return view
//    }()
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    var rentPrice:String!
    
    var gamePricee:Int!
    
    var InternalGamePrice:Int!
    
    
    
    var discountCode:String = ""
    
    var StateList: BottomList!
    var rentTypeId:Int?
    var currentStateId:Int!
    var currentCityId:Int!
    var game:Game!
    var rentPercent:Int!
    var selectedPeriod:String!
    var withWallet:Bool = true
    var gameIsforRent:Bool = false
     var contentFont:UIFont!
    var ePayment:RentEpay!
    var walletPayment:RentWallet!
    let image : UIImageView = {
        var image = UIImage()
        var img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    let firstView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 5
        return view
    }()
    let secondView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    let thirdView:UIView = {
         var view = UIView()
         view.layer.cornerRadius = 5
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.clear
         return view
     }()
    let fourthView:UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    let productLabel:UILabel = {
        var label = UILabel()
        label.text = "مشخصات بازی"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gameName:UILabel = {
       var name = UILabel()
        name.text = " نام بازی :"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: "IRANSans",size: 13)
        name.textColor = .lightGray
        name.textAlignment = .right
        return name
    }()
    let gameRegion:UILabel = {
          var name = UILabel()
           name.text = " ریجن : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 13)
           name.textColor = .lightGray
           name.textAlignment = .right
           return name
       }()
    let gamegenre:UILabel = {
          var name = UILabel()
           name.text = " ژانر : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 13)
           name.textColor = .lightGray
           name.textAlignment = .right
           return name
       }()
    let gameRentPriod:UILabel = {
          var name = UILabel()
           name.text = " بازه زمانی : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 13)
           name.textColor = .lightGray
           name.textAlignment = .right
           return name
       }()
    
    let deliverPeriodLabel:UILabel = {
        var label = UILabel()
        label.text = "تحویل :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deliverPeriod:UISegmentedControl = {
        var segment = UISegmentedControl()
        segment.insertSegment(withTitle: "۱۵ تا ۱۹", at: 0, animated: true)
        segment.insertSegment(withTitle: "۱۲ تا ۱۵", at: 1, animated: true)
        segment.insertSegment(withTitle: "۹ تا ۱۲", at: 2, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = .easyBaziTheme
        segment.selectedSegmentIndex = 0
        let attr:[AnyHashable:Any] = [NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.white]
        if #available(iOS 13.0, *) {
                  segment.selectedSegmentTintColor = UIColor.easyBaziTheme
              }
        segment.tintColor = .white
        segment.setTitleTextAttributes(attr, for: UIControlState.normal)
        segment.layer.borderWidth = 0.5
        segment.layer.borderColor = UIColor.backgroundThem.cgColor
        return segment
    }()
    
       let turnBackPeriodLabel:UILabel = {
            var label = UILabel()
            label.text = "بازگرداندن :"
            label.textColor = .lightGray
            label.font = UIFont(name: "IRANSans", size:13)
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let turnBackPeriod:UISegmentedControl = {
            var segment = UISegmentedControl()
            segment.insertSegment(withTitle: "۱۵ تا ۱۹", at: 0, animated: true)
            segment.insertSegment(withTitle: "۱۲ تا ۱۵", at: 1, animated: true)
            segment.insertSegment(withTitle: "۹ تا ۱۲", at: 2, animated: true)
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
            return segment
        }()

    let thirdViewLabel:UILabel = {
        var label = UILabel()
        label.text = " ساعات مناسب  جهت تحویل و بازگرداندن بازی"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let address:UILabel = {
        var label = UILabel()
        label.text = "آدرس و اطلاعات تماس"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let state:UILabel = {
       var add = UILabel()
        add.translatesAutoresizingMaskIntoConstraints = false
        add.textColor = .white
        add.textAlignment = .right
        add.layer.borderColor = UIColor.black.cgColor
        add.numberOfLines = 0
        add.text = ""
        add.backgroundColor = UIColor.clear
        add.font = UIFont(name: "IRANSans", size: 13)
        return add
    }()
    let city:UILabel = {
        var add = UILabel()
        add.translatesAutoresizingMaskIntoConstraints = false
        add.textColor = .white
        add.textAlignment = .right
        add.layer.borderColor = UIColor.black.cgColor
        add.numberOfLines = 0
        add.text = ""
        add.backgroundColor = UIColor.clear
        add.font = UIFont(name: "IRANSans", size: 13)
        return add
    }()
    let selectStateBtn:UIButton = {
       var btn = UIButton()
        btn.setTitle("انتخاب", for: UIControlState.normal)
        btn.titleLabel?.textAlignment = .right
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 11)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.easyBaziTheme.cgColor
        btn.layer.cornerRadius = 5
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(handleStates), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    //third View Component
    let payment:UILabel = {
        var label = UILabel()
        label.text = "اطلاعات پرداخت"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gamePriceLabel:UILabel = {
        var label = UILabel()
        label.text = "قیمت بازی :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gamePrice:UILabel = {
        var label = UILabel()
        label.text = " ۹۹۹.۹۹۹ تومان "
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gameRentLabel:UILabel = {
        var label = UILabel()
        label.text = "هزینه کرایه :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gameRentPrice:UILabel = {
        var label = UILabel()
        label.text = " ۹۹۹.۹۹۹ تومان "
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gamePostPriceLabel:UILabel = {
        var label = UILabel()
        label.text = "هزینه ارسال :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gamePostPrice:UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalPriceLabel:UILabel = {
        var label = UILabel()
        label.text = "مجموع پرداختی :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalPrice:UILabel = {
        var label = UILabel()
        label.text = " ۹۹۹.۹۹۹ تومان "
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let btnStack:UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.backgroundColor = .red
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let discountStack:UIStackView = {
           var stack = UIStackView()
           stack.axis = .horizontal
           stack.spacing = 8
           stack.backgroundColor = .red
           stack.distribution = .fillEqually
           stack.translatesAutoresizingMaskIntoConstraints = false
           return stack
       }()
    let ePayButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("پرداخت اینترنتی", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:14)
        btn.titleLabel?.textColor = .red
        btn.backgroundColor = UIColor.easyBaziGreen
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.backgroundThem.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleAddressEpay), for: UIControlEvents.touchDown)
        return btn
    }()
    let discountButton : UIButton = {
           var btn = UIButton()
           btn.setTitle(" اعمال", for: UIControlState.normal)
           btn.titleLabel?.font = UIFont(name: "IRANSans", size:12)
           btn.titleLabel?.textColor = .easyBaziTheme
           btn.backgroundColor = UIColor.easyBaziTheme
           btn.titleLabel?.textAlignment = .center
           btn.translatesAutoresizingMaskIntoConstraints = false
           btn.layer.cornerRadius = 5
           btn.addTarget(self, action: #selector(handleDiscount), for: .touchDown)
           return btn
       }()
    let discountInput:UITextField = {
          var post = UITextField()
           post.backgroundColor = UIColor.darkGray
           post.layer.borderColor = UIColor.backgroundThem.cgColor
           post.layer.borderWidth = 1.0
           post.textColor = UIColor.white
           post.placeholder = "  کد تخفیف را وارد کنید."
           post.borderStyle = .roundedRect
           post.textAlignment = .center
           post.layer.cornerRadius = 5
           post.font = UIFont(name: "IRANSans", size: 13)
           post.attributedPlaceholder =
               NSAttributedString(string: "  کد تخفیف را وارد کنید.", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.5)])
           post.translatesAutoresizingMaskIntoConstraints = false
           post.keyboardType = .default
           return post
       }()
    let localPayButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("پرداخت با اعتبار", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.textColor = UIColor.easyBaziTheme
        btn.backgroundColor = UIColor.color(red: 58, green: 58, blue: 66, alpha: 1)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.backgroundThem.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleAddressWallet), for: .touchDown)
        return btn
    }()
   
    //Get States Of Contury Here
    @objc fileprivate func handleStates(){
        StateList.getStates()
        StateList.rentViewController = self
    }
    var font:UIFont!
    let selectCityBtn:UIButton = {
        var btn = UIButton()
        btn.setTitle("انتخاب", for: UIControlState.normal)
        btn.titleLabel?.textAlignment = .right
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 11)
        btn.layer.opacity = 0.6
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleCities), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    public func rentGameWithePay(_ addressId:Int) {
        if discountInput.text != nil{
            discountCode = discountInput.text!
        }else{
            discountCode = ""
        }
        RentGameEpay.pay(getToken(), gameId: game.id, rentTypeId: rentTypeId!, addressId: addressId, discountCode: discountCode) { (link, status, message) in
            self.ePayment.dismiss()
            if status == 1{
                self.navigationController?.popToRootViewController(animated: true)
                 UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                self.ePayment.removeCoverView()
                //update activity
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userRented"), object: nil)
            }else{
                self.ePayment.removeCoverView()
                SVProgressHUD.showError(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 3)
                print("Error in getting link for rent game by ePay")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    public func rentGameWithWallet(_ addressId:Int) {
        if discountInput.text != nil{
            discountCode = discountInput.text!
            
        }else{
            discountCode = ""
        }
        RentGameWallet.pay(getToken(), gameId: game.id, rentTypeId: rentTypeId!, addressId: addressId, discountCode: discountCode) { (status, message) in
        self.walletPayment.dismiss()
            if status == 1{
                SVProgressHUD.showSuccess(withStatus: message)
                self.navigationController?.popToRootViewController(animated: true)
                SVProgressHUD.dismiss(withDelay: 3)
                self.walletPayment.removeCoverView()
                //update activity
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userRented"), object: nil)
            }else{
                self.walletPayment.removeCoverView()
                SVProgressHUD.showError(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 3)
                self.navigationController?.popToRootViewController(animated: true)
                print("Error in getting link for rent game by Wallet")
            }
        }
    }
        //handle ePay of rent action
    @objc fileprivate func handleAddressEpay(){
        view.endEditing(true)
        if state.text != "" && city.text != "" && mobileNumberInput.text != "" && postalCodeInput.text != "" && addressInput.text != ""{
                        //getting address id from server
                              let phone = Int(mobileNumberInput.text!)
                    let post = Int(postalCodeInput.text!)
                    ePayment = RentEpay(stateId: currentStateId, cityId: currentCityId, postCode: post!
                        , content: addressInput.text,phoneNumber:phone!)
                    ePayment.rentVC = self
                    ePayment.show()
                }else{
                    let alert = UIAlertController(title: "توجه!!!", message: "لطفا اطلاعات آدرس را مجددا بررسی فرمایید.", preferredStyle: UIAlertControllerStyle.actionSheet)
                    let action = UIAlertAction(title: "باشه", style: UIAlertActionStyle.destructive, handler: nil)
                    alert.addAction(action)
                    alert.setValue(NSAttributedString(string:  "لطفا اطلاعات آدرس را مجددا بررسی فرمایید.", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                    alert.setValue(NSAttributedString(string:  "توجه!!!", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                    self.present(alert, animated: true, completion: nil)
                          }
    }
     //handle ePay of rent action
    @objc fileprivate func handleAddressWallet(){
        view.endEditing(true)
         if state.text != "" && city.text != "" && mobileNumberInput.text != "" && postalCodeInput.text != "" && addressInput.text != ""{
                         //getting address id from server
                               let phone = Int(mobileNumberInput.text!)
                               let post = Int(postalCodeInput.text!)
                               walletPayment = RentWallet(stateId: currentStateId, cityId: currentCityId, postCode: post!
                                   , content: addressInput.text,phoneNumber:phone!)
                               walletPayment.rentVC = self
                               walletPayment.show()
                           }else{
                                 let alert = UIAlertController(title: "توجه!!!", message: "لطفا اطلاعات آدرس را مجددا بررسی فرمایید.", preferredStyle: UIAlertControllerStyle.actionSheet)
                                 let action = UIAlertAction(title: "باشه", style: UIAlertActionStyle.destructive, handler: nil)
                                 alert.addAction(action)
                                               alert.setValue(NSAttributedString(string:  "لطفا اطلاعات آدرس را مجددا بررسی فرمایید.", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                                               alert.setValue(NSAttributedString(string:  "توجه!!!", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                               
                                 self.present(alert, animated: true, completion: nil)
                           }
     }
    
    
    //Get Cities Of State Here
    @objc fileprivate func handleCities(){
       
        if currentStateId != nil {
            selectCityBtn.isEnabled = true
            StateList.getCities(cityId: currentStateId)
            StateList.rentViewController = self
        }else{
           
        }
    }
    let nameLabel:UILabel = {
        var label = UILabel()
        label.text = "Red dead redemption 2 "
        label.textColor = .white
        label.font = UIFont(name: "San Francisco Display", size:16)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    
    let stateLabel:UILabel = {
        var label = UILabel()
        label.text = "استان :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let cityLabel:UILabel = {
        var label = UILabel()
        label.text = "شهر :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addressLabel:UILabel = {
        var label = UILabel()
        label.text = "آدرس :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let postCodeInput:UITextField = {
       var post = UITextField()
        post.backgroundColor = UIColor.darkGray
        post.layer.borderColor = UIColor.backgroundThem.cgColor
        post.layer.borderWidth = 1.0
        post.textColor = UIColor.white
        
        post.borderStyle = .roundedRect
        post.textAlignment = .center
        post.layer.cornerRadius = 5
        post.font = UIFont(name: "IRANSans", size: 13)
         post.translatesAutoresizingMaskIntoConstraints = false
        post.keyboardType = .numberPad
        return post
    }()
    let addressInput:UITextView = {
        var post = UITextView()
        post.backgroundColor = UIColor.clear
        post.layer.borderColor = UIColor.easyBaziTheme.cgColor
        post.layer.borderWidth = 1.0
        post.layer.cornerRadius = 5
        post.textColor = UIColor.white
        post.textAlignment = .right
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.keyboardType = .default
        return post
    }()
    let mobileLabel:UILabel = {
        var label = UILabel()
        label.text = "موبایل :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let postalCodeLabel:UILabel = {
        var label = UILabel()
        label.text = "کد پستی :"
        label.textColor = .lightGray
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let mobileNumberInput:UITextField = {
        var post = UITextField()
        post.backgroundColor = UIColor.clear
        post.layer.borderColor = UIColor.easyBaziTheme.cgColor
        post.layer.borderWidth = 1.0
        post.borderStyle = .roundedRect
        post.textColor = UIColor.white
        post.layer.cornerRadius = 5
        post.textAlignment = .center
        post.placeholder = "اجباری"
        post.attributedPlaceholder =
            NSAttributedString(string: "اجباری", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.5)])
        
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.keyboardType = .asciiCapableNumberPad
        return post
    }()
    let postalCodeInput:UITextField = {
        var post = UITextField()
        post.backgroundColor = UIColor.clear
        post.layer.borderColor = UIColor.easyBaziTheme.cgColor
        post.layer.borderWidth = 1.0
        post.borderStyle = .roundedRect
        post.textColor = UIColor.white
        post.placeholder = "کد ده دقمی"
        post.attributedPlaceholder =
            NSAttributedString(string: "کد ده دقمی", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.5)])
        
        post.layer.cornerRadius = 5
        post.textAlignment = .center
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.keyboardType = .asciiCapableNumberPad
        return post
    }()
    let region:UILabel = {
        var label = UILabel()
        label.text = "All"
        label.textColor = .white
        label.font = UIFont(name: "San Francisco Display", size:16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let genre:UILabel = {
          var label = UILabel()
          label.text = ""
          label.textColor = .white
          label.font = UIFont(name: "IRANSans", size:13)
          label.textAlignment = .left
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    let period:UILabel = {
        var label = UILabel()
           label.text = ""
           label.textColor = .white
           label.font = UIFont(name: "IRANSans", size:15)
           label.textAlignment = .left
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    let dividerView:UIView = {
         var view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.easyBaziTheme
         view.layer.cornerRadius = 5
        view.alpha = 0.45
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
    let dividerView8:UIView = {
              var view = UIView()
              view.translatesAutoresizingMaskIntoConstraints = false
              view.backgroundColor = UIColor.easyBaziTheme
              view.layer.cornerRadius = 5
             view.alpha = 0.45
              return view
          }()
    let dividerView9:UIView = {
              var view = UIView()
              view.translatesAutoresizingMaskIntoConstraints = false
              view.backgroundColor = UIColor.easyBaziTheme
              view.layer.cornerRadius = 5
             view.alpha = 0.45
              return view
          }()
    let dividerView10:UIView = {
                 var view = UIView()
                 view.translatesAutoresizingMaskIntoConstraints = false
                 view.backgroundColor = UIColor.easyBaziTheme
                 view.layer.cornerRadius = 5
                view.alpha = 0.45
                 return view
             }()
    let dividerView11:UIView = {
                 var view = UIView()
                 view.translatesAutoresizingMaskIntoConstraints = false
                 view.backgroundColor = UIColor.easyBaziTheme
                 view.layer.cornerRadius = 5
                view.alpha = 0.45
                 return view
             }()
    let dividerView12:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.layer.cornerRadius = 5
       view.alpha = 0.45
        return view
    }()
    let dividerView13:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.layer.cornerRadius = 5
       view.alpha = 0.45
        return view
    }()
    let dividerView14:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.layer.cornerRadius = 5
       view.alpha = 0.45
        return view
    }()
    
    let dividerView15:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.layer.cornerRadius = 5
       view.alpha = 0.45
        return view
    }()
    
    let dividerView16:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        view.layer.cornerRadius = 5
       view.alpha = 0.45
        return view
    }()
    
      let dividerView17:UIView = {
          var view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = UIColor.easyBaziTheme
          view.layer.cornerRadius = 5
         view.alpha = 0.45
          return view
      }()

    @objc func handleUserLogout(){
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "کرایه بازی"
        gamePricee = game.price
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLogout), name: NSNotification.Name("userLogout"), object: nil)
        postalCodeInput.delegate = self
        mobileNumberInput.delegate = self
        view.backgroundColor = UIColor.backgroundThem
        scrollView.bounces = true
        font = UIFont(name: "IRANSans", size: 13)
        SVProgressHUD.setFont(self.font)
        addressInput.delegate = self
        StateList = BottomList()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        hideKeyboardWhenTappedAround()
        // ADD VIEW'S
        containerView.backgroundColor = UIColor.backgroundThem
//        containerView.addSubview(productLabel)
//        containerView.addSubview(firstView)
//        fvSetup1()
        containerView.addSubview(address)
        containerView.addSubview(secondView)
        secondSetup()
        containerView.addSubview(thirdViewLabel)
        containerView.addSubview(thirdView)
        tvSetup()
        
        containerView.addSubview(payment)
        containerView.addSubview(fourthView)
        fvSetup()
        
        
        //first view items
//        firstView.addSubview(productLabel)
//        productLabelSetup()
//        firstView.addSubview(nameLabel)
//        nameLabelSetup()
//        firstView.addSubview(region)
//        regionSetup()
//        firstView.addSubview(genre)
//        genreSetup()
//        firstView.addSubview(gameName)
//        gameNameSetup()
//        firstView.addSubview(gameRegion)
//        gameRegionSetup()
//        firstView.addSubview(gamegenre)
//        gameGenreSetup()

        secondView.addSubview(stateLabel)
        locationLabelSetup()
        secondView.addSubview(state)
        secondView.addSubview(selectStateBtn)
        setupStateSelectBtn()
        labelSetup()
        secondView.addSubview(cityLabel)
        setupCityLabel()
        secondView.addSubview(city)
        secondView.addSubview(selectCityBtn)
        setupCitySelectBtn()
        citySetup()
        
        secondView.addSubview(addressLabel)
        setupAddress()
        secondView.addSubview(addressInput)
        setupAddressInput()
        secondView.addSubview(mobileLabel)
        setupMobileLabel()
        secondView.addSubview(mobileNumberInput)
        setupMobileInput()
        secondView.addSubview(postalCodeLabel)
        setuPostalCodelabel()
        secondView.addSubview(postalCodeInput)
        setupPostalCodeInput()
        
         //third view configuration
        thirdView.addSubview(deliverPeriodLabel)
        thirdView.addSubview(deliverPeriod)
        setupDeliverPeriod()
        thirdView.addSubview(turnBackPeriodLabel)
        thirdView.addSubview(turnBackPeriod)
        setupTurnBackPeriod()
        
        
        
        //fourth view configuration
//        thirdView.addSubview(payment)
//        paymentLabelSetup()
        fourthView.addSubview(gamePriceLabel)
        setupPriceLabel()
        fourthView.addSubview(gamePrice)
        setupPrice()
        
        fourthView.addSubview(gameRentLabel)
        setupRentPriceLabel()
        fourthView.addSubview(gameRentPrice)
        setupRentPrice()
        fourthView.addSubview(gamePostPriceLabel)
        setupPostPriceLabel()
        fourthView.addSubview(gamePostPrice)
        setupPostPrice()
        fourthView.addSubview(period)
        periodSetup()
        fourthView.addSubview(gameRentPriod)
        gameRentPriodSetup()
        fourthView.addSubview(totalPriceLabel)
        setupTotalPriceLabel()
        fourthView.addSubview(totalPrice)
        setupTotalPrice()
       
        fourthView.addSubview(discountInput)
        fourthView.addSubview(discountButton)
        setupDiscount()
        fourthView.addSubview(btnStack)
        setupStackView()
//        discountButton.addTarget(self, action: #selector(handleDiscount), for: .touchUpInside)
    }

    //third view setup
    
        fileprivate func setupDeliverPeriod(){
//            thirdViewLabel.topAnchor.constraint(equalTo: dividerView9.bottomAnchor, constant: 32).isActive = true
//            thirdViewLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
            deliverPeriodLabel.topAnchor.constraint(equalTo: thirdView.topAnchor, constant:20 ).isActive = true
            deliverPeriodLabel.trailingAnchor.constraint(equalTo: thirdView.trailingAnchor, constant: -8).isActive = true
            deliverPeriodLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
            
            deliverPeriod.topAnchor.constraint(equalTo: thirdView.topAnchor, constant: 16).isActive = true
            deliverPeriod.leftAnchor.constraint(equalTo: thirdView.leftAnchor, constant: 8).isActive = true
            deliverPeriod.rightAnchor.constraint(equalTo: deliverPeriodLabel.leftAnchor, constant: 0).isActive = true
            thirdView.addSubview(dividerView10)
            dividerView10.topAnchor.constraint(equalTo: deliverPeriod.bottomAnchor, constant: 8).isActive = true
            dividerView10.leftAnchor.constraint(equalTo: thirdView.leftAnchor, constant: 0).isActive = true
            dividerView10.rightAnchor.constraint(equalTo: thirdView.rightAnchor, constant: 0).isActive = true
            dividerView10.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        fileprivate func setupTurnBackPeriod(){
            turnBackPeriodLabel.topAnchor.constraint(equalTo: dividerView10.bottomAnchor, constant:20 ).isActive = true
            turnBackPeriodLabel.trailingAnchor.constraint(equalTo: thirdView.trailingAnchor, constant: -16).isActive = true
            turnBackPeriodLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
            
            turnBackPeriod.topAnchor.constraint(equalTo: dividerView10.bottomAnchor, constant: 16).isActive = true
            turnBackPeriod.leftAnchor.constraint(equalTo: thirdView.leftAnchor, constant: 8).isActive = true
            turnBackPeriod.rightAnchor.constraint(equalTo: turnBackPeriodLabel.leftAnchor, constant: 0).isActive = true
            thirdView.addSubview(dividerView11)
            dividerView11.topAnchor.constraint(equalTo: turnBackPeriod.bottomAnchor, constant: 8).isActive = true
            dividerView11.leftAnchor.constraint(equalTo: thirdView.leftAnchor, constant: 0).isActive = true
            dividerView11.rightAnchor.constraint(equalTo: thirdView.rightAnchor, constant: 0).isActive = true
            dividerView11.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
    
    fileprivate func tvSetup(){
        thirdViewLabel.topAnchor.constraint(equalTo: secondView.bottomAnchor, constant: 24).isActive = true
        thirdViewLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = thirdView.topAnchor.constraint(equalTo: thirdViewLabel.bottomAnchor, constant: 8)
        let right = thirdView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = thirdView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        let contentSize = CGSize(width: containerView.frame.width, height: 1000)
        let contentEstimatedFrame = NSString(string: stateLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
    
        let height = thirdView.heightAnchor.constraint(equalToConstant: (contentEstimatedFrame.height * 2) + 2 * 16 + 6 * 8 )

        NSLayoutConstraint.activate([top,right,left,height])
    }
    

    //fourth view constraints
    
    fileprivate func setupDiscount(){
//        discountStack.addArrangedSubview(discountButton)
//        discountStack.addArrangedSubview(discountInput)
        discountInput.topAnchor.constraint(equalTo: dividerView16.bottomAnchor, constant: 8).isActive = true
        discountInput.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        discountInput.widthAnchor.constraint(equalTo: fourthView.widthAnchor, multiplier: 0.7).isActive = true
        discountButton.topAnchor.constraint(equalTo: dividerView16.bottomAnchor, constant: 8).isActive = true
        discountButton.rightAnchor.constraint(equalTo: discountInput.leftAnchor, constant: -8).isActive = true
        discountButton.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        
        fourthView.addSubview(dividerView17)
                   dividerView17.topAnchor.constraint(equalTo: discountInput.bottomAnchor, constant: 8).isActive = true
                   dividerView17.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 0).isActive = true
                   dividerView17.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: 0).isActive = true
                   dividerView17.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    fileprivate func setupStackView(){
        btnStack.addArrangedSubview(localPayButton)
        btnStack.addArrangedSubview(ePayButton)
//        btnStack.topAnchor.constraint(equalTo: dividerView17.bottomAnchor, constant: 24).isActive = true
        btnStack.topAnchor.constraint(equalTo: dividerView17.bottomAnchor, constant: 16).isActive = true
        btnStack.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        btnStack.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
    }
    
    fileprivate func setupTotalPrice(){
        totalPrice.topAnchor.constraint(equalTo: dividerView15.bottomAnchor, constant: 8).isActive = true
        totalPrice.rightAnchor.constraint(equalTo: totalPriceLabel.leftAnchor, constant: 8).isActive = true
        totalPrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        let gamePrice = Int(game.price)
        let rentPrice = (gamePrice/100*rentPercent)
        let postPrice = 10000
        let total = gamePrice + rentPrice + postPrice
        
        totalPrice.text = convertToPersian(inputStr: String(describing:"\(total.formattedWithSeparator)")) + " تومان"
        
    }
    fileprivate func setupTotalPriceLabel(){
        totalPriceLabel.topAnchor.constraint(equalTo: dividerView15.bottomAnchor, constant: 8).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        fourthView.addSubview(dividerView16)
        dividerView16.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 8).isActive = true
        dividerView16.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 0).isActive = true
        dividerView16.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: 0).isActive = true
        dividerView16.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    fileprivate func setupPostPrice(){
        gamePostPrice.topAnchor.constraint(equalTo: dividerView13.bottomAnchor, constant: 8).isActive = true
        gamePostPrice.rightAnchor.constraint(equalTo: gamePostPriceLabel.leftAnchor, constant: 8).isActive = true
        gamePostPrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        gamePostPrice.text = "۰" + " تومان "
        
    }
   fileprivate func setupPostPriceLabel(){
        gamePostPriceLabel.topAnchor.constraint(equalTo: dividerView13.bottomAnchor, constant: 8).isActive = true
        gamePostPriceLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        fourthView.addSubview(dividerView14)
                  dividerView14.topAnchor.constraint(equalTo: gamePostPriceLabel.bottomAnchor, constant: 8).isActive = true
                  dividerView14.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 0).isActive = true
                  dividerView14.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: 0).isActive = true
                  dividerView14.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    fileprivate func setupRentPrice(){
        
        gameRentPrice.topAnchor.constraint(equalTo: dividerView12.bottomAnchor, constant: 8).isActive = true
        gameRentPrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        InternalGamePrice = Int(game.price)/100
        rentPrice = (InternalGamePrice*rentPercent).formattedWithSeparator
        gameRentPrice.text = convertToPersian(inputStr: "\(String(describing: rentPrice!))") + " تومان "
        
    }
    fileprivate func setupRentPriceLabel(){
        gameRentLabel.topAnchor.constraint(equalTo: dividerView12.bottomAnchor, constant: 8).isActive = true
        gameRentLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        fourthView.addSubview(dividerView13)
        dividerView13.topAnchor.constraint(equalTo: gameRentLabel.bottomAnchor, constant: 8).isActive = true
        dividerView13.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 0).isActive = true
        dividerView13.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: 0).isActive = true
        dividerView13.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    fileprivate func setupPrice(){
        gamePrice.topAnchor.constraint(equalTo: fourthView.topAnchor, constant: 8).isActive = true
        gamePrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        gamePrice.text = convertToPersian(inputStr: "\(Int(game.price).formattedWithSeparator)") + " تومان "
        
    }
    fileprivate func setupPriceLabel(){
       
        gamePriceLabel.topAnchor.constraint(equalTo: fourthView.topAnchor, constant: 8).isActive = true
        gamePriceLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        fourthView.addSubview(dividerView12)
        dividerView12.topAnchor.constraint(equalTo: gamePriceLabel.bottomAnchor, constant: 8).isActive = true
        dividerView12.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 0).isActive = true
        dividerView12.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: 0).isActive = true
        dividerView12.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    
    
    
    
    
    
    //second view
    

    
    fileprivate func setupPostalCodeInput(){
        postalCodeInput.topAnchor.constraint(equalTo: dividerView8.bottomAnchor, constant:8 ).isActive = true
        postalCodeInput.rightAnchor.constraint(equalTo: postalCodeLabel.leftAnchor, constant: 0).isActive = true
        postalCodeInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
//        secondView.addSubview(dividerView9)
//                     dividerView9.topAnchor.constraint(equalTo: postalCodeInput.bottomAnchor, constant: 8).isActive = true
//                     dividerView9.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 0).isActive = true
//                     dividerView9.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: 0).isActive = true
//                     dividerView9.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func setuPostalCodelabel(){
        postalCodeLabel.topAnchor.constraint(equalTo: dividerView8.bottomAnchor, constant:8 ).isActive = true
        postalCodeLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -8).isActive = true
        postalCodeLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
    }
    fileprivate func setupMobileInput(){
        mobileNumberInput.topAnchor.constraint(equalTo: dividerView7.bottomAnchor, constant:8 ).isActive = true
        mobileNumberInput.rightAnchor.constraint(equalTo: mobileLabel.leftAnchor, constant: 0).isActive = true
        mobileNumberInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        secondView.addSubview(dividerView8)
        dividerView8.topAnchor.constraint(equalTo: mobileNumberInput.bottomAnchor, constant: 8).isActive = true
        dividerView8.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 0).isActive = true
        dividerView8.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: 0).isActive = true
        dividerView8.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func setupMobileLabel(){
        mobileLabel.topAnchor.constraint(equalTo: dividerView7  .bottomAnchor, constant: 8).isActive = true
        mobileLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -8).isActive = true
        mobileLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
    }
    fileprivate func setupAddressInput(){
//        addressInput.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillShown)))
        addressInput.topAnchor.constraint(equalTo: dividerView6.bottomAnchor, constant:16 ).isActive = true
        addressInput.rightAnchor.constraint(equalTo: addressLabel.leftAnchor, constant: 0).isActive = true
        addressInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        addressInput.heightAnchor.constraint(equalToConstant: view.frame.size.height / 11).isActive = true
        secondView.addSubview(dividerView7)
        dividerView7.topAnchor.constraint(equalTo: addressInput.bottomAnchor, constant: 8).isActive = true
        dividerView7.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 0).isActive = true
        dividerView7.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: 0).isActive = true
        dividerView7.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func setupAddress(){
        addressLabel.topAnchor.constraint(equalTo: dividerView6.bottomAnchor, constant: 16).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -8).isActive = true
        addressLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
      
    }
    fileprivate func setupCitySelectBtn(){
        selectCityBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        selectCityBtn.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor).isActive = true
        selectCityBtn.widthAnchor.constraint(equalToConstant: view.frame.width/8).isActive = true
        secondView.addSubview(dividerView6)
            dividerView6.topAnchor.constraint(equalTo: selectCityBtn.bottomAnchor, constant: 8).isActive = true
            dividerView6.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 0).isActive = true
            dividerView6.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: 0).isActive = true
            dividerView6.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    fileprivate func citySetup(){
        city.rightAnchor.constraint(equalTo: cityLabel.leftAnchor, constant: -8).isActive = true
        city.leftAnchor.constraint(equalTo: selectCityBtn.rightAnchor, constant: 8).isActive = true
        city.topAnchor.constraint(equalTo: dividerView5.bottomAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setupCityLabel(){
        cityLabel.topAnchor.constraint(equalTo: dividerView5.bottomAnchor, constant:16 ).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    
    fileprivate func setupStateSelectBtn(){
        
        selectStateBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        selectStateBtn.centerYAnchor.constraint(equalTo: stateLabel.centerYAnchor).isActive = true
        selectStateBtn.widthAnchor.constraint(equalToConstant: view.frame.width/8).isActive = true
        secondView.addSubview(dividerView5)
        dividerView5.topAnchor.constraint(equalTo: selectStateBtn.bottomAnchor, constant: 8).isActive = true
        dividerView5.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 0).isActive = true
        dividerView5.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: 0).isActive = true
        dividerView5.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func mobileNubmerInputSetup(){
        mobileNumberInput.rightAnchor.constraint(equalTo: mobileLabel.leftAnchor, constant: -8).isActive = true
        mobileNumberInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        mobileNumberInput.topAnchor.constraint(equalTo: dividerView7.bottomAnchor, constant: 14).isActive = true
        secondView.addSubview(dividerView8)
        dividerView8.topAnchor.constraint(equalTo: mobileNumberInput.bottomAnchor, constant: 8).isActive = true
        dividerView8.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 0).isActive = true
        dividerView8.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: 0).isActive = true
        dividerView8.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    fileprivate func mobileLabelSetup(){
        mobileLabel.topAnchor.constraint(equalTo: postCodeInput.bottomAnchor, constant: 16 ).isActive = true
        mobileLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func postCodeInputSetup(){
        postCodeInput.rightAnchor.constraint(equalTo: cityLabel.leftAnchor, constant: -8).isActive = true
        postCodeInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        postCodeInput.topAnchor.constraint(equalTo: state.bottomAnchor, constant: 14).isActive = true
        
    }
    fileprivate func postLabelSetup(){
        cityLabel.topAnchor.constraint(equalTo: state.bottomAnchor, constant: 16 ).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -16).isActive = true
    }
    fileprivate func locationLabelSetup(){
        stateLabel.topAnchor.constraint(equalTo: address.bottomAnchor, constant:16 ).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func labelSetup(){
        state.rightAnchor.constraint(equalTo: stateLabel.leftAnchor, constant: -8).isActive = true
        state.leftAnchor.constraint(equalTo: selectStateBtn.rightAnchor, constant: 8).isActive = true
//        state.widthAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
        state.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 8).isActive = true
//        state.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    fileprivate func addressLabelSetup(){
        address.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 16).isActive = true
        address.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -16).isActive = true
    }
    
    
     //first view
    
    
    fileprivate func gameNameSetup(){
        gameName.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 8).isActive = true
        gameName.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
        firstView.heightAnchor.constraint(equalToConstant: 173).isActive = true
        dividerView.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 8).isActive = true
        dividerView.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 0).isActive = true
        dividerView.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: 0).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func gameRegionSetup(){
        firstView.addSubview(dividerView2)
        gameRegion.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8).isActive = true
        gameRegion.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
        dividerView2.topAnchor.constraint(equalTo: gameRegion.bottomAnchor, constant: 8).isActive = true
        dividerView2.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 0).isActive = true
        dividerView2.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: 0).isActive = true
        dividerView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func gameGenreSetup(){
        firstView.addSubview(dividerView3)
        gamegenre.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
        gamegenre.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
        dividerView3.topAnchor.constraint(equalTo: gamegenre.bottomAnchor, constant: 8).isActive = true
        dividerView3.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 0).isActive = true
        dividerView3.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: 0).isActive = true
        dividerView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    fileprivate func gameRentPriodSetup(){
          
          gameRentPriod.topAnchor.constraint(equalTo: dividerView14.bottomAnchor, constant: 8).isActive = true
          gameRentPriod.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        fourthView.addSubview(dividerView15)
        dividerView15.topAnchor.constraint(equalTo: gameRentPriod.bottomAnchor, constant: 8).isActive = true
        dividerView15.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 0).isActive = true
        dividerView15.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: 0).isActive = true
        dividerView15.heightAnchor.constraint(equalToConstant: 1).isActive = true
      }
    
    fileprivate func nameLabelSetup(){
           nameLabel.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 10).isActive = true
           nameLabel.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
           nameLabel.text = game.game_info.name
       }
    fileprivate func regionSetup(){
        region.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        region.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
        region.text = game.region
    }
    fileprivate func genreSetup(){
        genre.topAnchor.constraint(equalTo: region.bottomAnchor, constant: 20).isActive = true
        genre.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
        if game.game_info.genres.count != 0{
            if game.game_info.genres.count > 1{
              for genree in game.game_info.genres{
                  if genree.name == game.game_info.genres[0].name{
                    genre.text = genree.name
                  }else{
                     genre.text = genre.text! + "," + genree.name
                  }
                  
                  }
              }else{
                  genre.text = game.game_info.genres[0].name
              }
        }else{
            genre.text = "ندارد !"
        }
        
    }
    fileprivate func periodSetup(){
         period.topAnchor.constraint(equalTo: dividerView14.bottomAnchor, constant: 8).isActive = true
         period.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
         period.text = selectedPeriod + " روز "
     }

    // setup main views
    fileprivate func fvSetup(){
        payment.topAnchor.constraint(equalTo: thirdView.bottomAnchor, constant: 24).isActive = true
        payment.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = fourthView.topAnchor.constraint(equalTo: payment.bottomAnchor, constant: 8)
        let bottom = fourthView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        let right = fourthView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = fourthView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        let contentSize = CGSize(width: containerView.frame.width, height: 1000)
        let contentEstimatedFrame = NSString(string: stateLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
        let height = fourthView.heightAnchor.constraint(equalToConstant: (contentEstimatedFrame.height * 7) + 7 * 16 + 6 * 8)
        NSLayoutConstraint.activate([top,right,left,height,bottom])

    }
    fileprivate func secondSetup(){
        address.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        address.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = secondView.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 8)
        let right = secondView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = secondView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        let addresHeight = view.frame.size.height / 11
        contentFont = UIFont(name: "IRANSans", size: 13)
        let contentSize = CGSize(width: containerView.frame.width, height: 1000)
        let contentEstimatedFrame = NSString(string: stateLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
        let heightSize = (contentEstimatedFrame.height * 5) + 4 * 16 + 6 * 8 + addresHeight/2 + 2 * 20
        let height = secondView.heightAnchor.constraint(equalToConstant: heightSize)
        NSLayoutConstraint.activate([top,right,left,height])
    }
    fileprivate func fvSetup1(){
        firstView.addSubview(dividerView)
        productLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        productLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = firstView.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 8)
        let right = firstView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = firstView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        NSLayoutConstraint.activate([top,right,left])

        
 }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
//
//    func textViewDidBeginEditing(_ textView: UITextView)
//    {
//        if textView == addressInput{
//            if (textView.text == "...آدرس کامل" )
//                   {
//
//                       textView.text = ""
//
//                       textView.textColor = .white
//                       textView.textAlignment = .right
//                   }
//                   textView.becomeFirstResponder() //Optional
//        }
//
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView)
//    {
//        if textView == addressInput{
//            if (textView.text == "")
//                   {
//                       textView.textColor = .lightGray
//                       textView.textAlignment = .center
//                       textView.text = "...آدرس کامل"
//
//                   }
//                   textView.resignFirstResponder()
//        }
//
//    }
    //Helper Methods
    @objc func keyboardWillShown(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        var tabHeight:CGFloat!
        if tabBarController?.tabBar.frame.height != nil{
            tabHeight = tabBarController?.tabBar.frame.size.height
        }else{
                    tabHeight = 49
        }
        let keyboardHeight = (keyboardSize?.height)! - (tabHeight)
        let inset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
    }
    @objc func keyboardWillHidden(notification: NSNotification) {
        let inset = UIEdgeInsets.zero
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var temp:Bool = false
        if textField == postalCodeInput{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            temp = newString.length <= maxLength
        }else if textField == mobileNumberInput{
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            temp = newString.length <= maxLength
        }
        return temp
    }
    
    
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    @objc func handleDiscount(){
   
        if discountInput.text!.count > 3  {
             SVProgressHUD.show(withStatus: "در حال انجام...")
            Discount.getInfo(for: discountInput.text!,token: getToken()) { (status, message, discountPercent) in
                if status == 1{
                    guard let discountPercent = discountPercent else{ return}
                    print(message)
                    SVProgressHUD.showSuccess(withStatus: "کد تخفیف اعمال شد.")
                    SVProgressHUD.dismiss(withDelay: 2)
                    self.InternalGamePrice = Int(self.game.price)/100
                    self.rentPrice = ((self.InternalGamePrice*self.rentPercent)/100*discountPercent).formattedWithSeparator
                    self.gameRentPrice.text = "  (تخفیف اعمال شد.) " +  self.convertToPersian(inputStr: "\(String(describing: self.rentPrice!))") + " تومان "
                    self.gameRentPrice.font = UIFont(name: "IRANSans", size: 12)
                    let total = self.gamePricee + ((self.InternalGamePrice*self.rentPercent)/100*discountPercent)
                          
                    self.totalPrice.text = self.convertToPersian(inputStr: String(describing:"\(total)")) + " تومان"
                    
                    self.discountButton.setTitle("اعمال شد.", for: .normal)
                    self.discountButton.isEnabled = false
                    self.discountInput.isEnabled = false
//                    SVProgressHUD.showSuccess(withStatus: "کد تخفیف با موفقیت اعمال شد.")
                    SVProgressHUD.dismiss(withDelay: 2)
                }else{
                    
                    SVProgressHUD.showError(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 4)
                }
            }
        }else{
            let alert = UIAlertController(title: "توجه!!!", message: "لطفا کد تخفیف را مجددا بررسی فرمایید.", preferredStyle: UIAlertControllerStyle.actionSheet)
            let action = UIAlertAction(title: "باشه", style: UIAlertActionStyle.destructive, handler: nil)
            alert.addAction(action)
            alert.setValue(NSAttributedString(string:  "لطفا کد تخفیف را مجددا بررسی فرمایید.", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            alert.setValue(NSAttributedString(string:  "توجه!!!", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

}
