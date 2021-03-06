//
//  ShopVC.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/10/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SafariServices
import SVProgressHUD

class ShopVC: UIViewController , UITextViewDelegate,SFSafariViewControllerDelegate,UITextFieldDelegate{
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
    var shopPercent:Int!
    var gamePricee:Int!
    var discountCode:String = ""
    var StateList: BottomListShop!
    var currentStateId:Int!
    var currentCityId:Int!
    var game:Game!
     var contentFont:UIFont!
    var ePayment:ShopEpay!
    var walletPayment:ShopWallet!
    var InternalGamePrice:Int!
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
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 5
        return view
    }()
    let secondView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    let thirdViewLabel:UILabel = {
        var label = UILabel()
        label.text = " ساعات مناسب  جهت تحویل بازی(فعلا در تبریز) :"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thirdView:UIView = {
         var view = UIView()
         view.layer.cornerRadius = 5
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.darkGray
         return view
     }()
    
    let fourthView:UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let deliverPeriodLabel:UILabel = {
         var label = UILabel()
         label.text = "تحویل :"
         label.textColor = .white
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
    
    let productLabel:UILabel = {
        var label = UILabel()
        label.text = "مشخصات محصول :"
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
        name.font = UIFont(name: "IRANSans",size: 15)
        name.textColor = .white
        name.textAlignment = .right
        return name
    }()
    let gameRegion:UILabel = {
          var name = UILabel()
           name.text = " ریجن : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 15)
           name.textColor = .white
           name.textAlignment = .right
           return name
       }()
    let gamegenre:UILabel = {
          var name = UILabel()
           name.text = " ژانر : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 15)
           name.textColor = .white
           name.textAlignment = .right
           return name
       }()
    let gameRentPriod:UILabel = {
          var name = UILabel()
           name.text = " بازه زمانی : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 15)
           name.textColor = .white
           name.textAlignment = .right
           return name
       }()
    let address:UILabel = {
        var label = UILabel()
        label.text = "آدرس و اطلاعات تماس :"
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
        label.text = "اطلاعات پرداخت :"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gamePriceLabel:UILabel = {
        var label = UILabel()
        label.text = "قیمت بازی :"
        label.textColor = .white
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
        label.textColor = .white
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
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gamePostPrice:UILabel = {
        var label = UILabel()
        label.text = " ۹۹۹.۹۹۹ تومان "
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let totalPriceLabel:UILabel = {
        var label = UILabel()
        label.text = "مجموع پرداختی :"
        label.textColor = .white
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
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleAddress), for: UIControlEvents.touchDown)
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
           btn.addTarget(self, action: #selector(handleDiscount), for: .touchDown)
           btn.layer.cornerRadius = 5
           return btn
       }()
    let discountInput:UITextField = {
          var post = UITextField()
           post.backgroundColor = UIColor.darkGray
           post.layer.borderColor = UIColor.black.cgColor
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
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleAddressWallet), for: .touchDown)
        return btn
    }()
   
    //Get States Of Contury Here
    @objc fileprivate func handleStates(){
        StateList.getStates()
        StateList.shopViewController = self
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
    
    let dividerView1:UIView = {
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
//fourth view dividers
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
    
    public func shopGameWithWallet(_ addressId:Int) {
        if discountInput.text != nil{
            discountCode = discountInput.text!
        }else{
            discountCode = ""
        }
        ShopGameWithWallet.pay(getToken(), gameId: game.id,addressId: addressId,discountCode:discountInput.text!) { (status, message) in
            self.walletPayment.dismiss()
               if status == 1{
                     SVProgressHUD.showSuccess(withStatus: message)
                     self.navigationController?.popToRootViewController(animated: true)
                     SVProgressHUD.dismiss(withDelay: 3)
                    self.walletPayment.removeCoverView()
                    //update activity
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userShoped"), object: nil)
               }else{
                    self.walletPayment.removeCoverView()
                     SVProgressHUD.showError(withStatus: message)
                     SVProgressHUD.dismiss(withDelay: 3)
                     print("Error in getting link for shop game by Wallet")
                     self.navigationController?.popToRootViewController(animated: true)
               }
           }
       }
    public func shopGameWithePay(_ addressId:Int) {
        if discountInput.text != nil{
            discountCode = discountInput.text!
            
        }else{
            discountCode = ""
        }
        ShopGameEpay.pay(getToken(), gameId: game.id,addressId: addressId, discountCode: discountCode) { (link, status, message) in
           self.ePayment.dismiss()
            if status == 1{
                self.navigationController?.popToRootViewController(animated: true)
                UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                self.ePayment.removeCoverView()
                //update activity
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userShoped"), object: nil)
            }else{
                 self.ePayment.removeCoverView()
                 SVProgressHUD.showError(withStatus: message)
                 SVProgressHUD.dismiss(withDelay: 3)
                 print("Error in getting link for shop game by ePay")
                 self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
        //handle ePay of rent action
    @objc fileprivate func handleAddress(){
        view.endEditing(true)
        if state.text != "" && city.text != "" && mobileNumberInput.text != "" && postalCodeInput.text != "" && addressInput.text != ""{
                        //getting address id from server
                              let phone = Int(mobileNumberInput.text!)
                              let post = Int(postalCodeInput.text!)
                            ePayment = ShopEpay(stateId: currentStateId, cityId: currentCityId, postCode: post!
                                                 , content: addressInput.text,phoneNumber:phone!)
                            ePayment.shopVC = self
                            ePayment.show()
                          }else{
                                let alert = UIAlertController(title: "توجه!!!", message: "لطفا اطلاعات آدرس را مجددا بررسی فرمایید.", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "باشه", style: UIAlertActionStyle.destructive, handler: nil)
                                alert.addAction(action)
                                              alert.setValue(NSAttributedString(string:  "لطفا اطلاعات آدرس را مجددا بررسی فرمایید.", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                                              alert.setValue(NSAttributedString(string:  "توجه!!!", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                              
                                self.present(alert, animated: true, completion: nil)
                              
                          }
    }
    
    
     //handle shop with wallet address
    @objc fileprivate func handleAddressWallet(){
        view.endEditing(true)
         if state.text != "" && city.text != "" && mobileNumberInput.text != "" && postalCodeInput.text != "" && addressInput.text != ""{
                         //getting address id from server
                               let phone = Int(mobileNumberInput.text!)
                               let post = Int(postalCodeInput.text!)
                               walletPayment = ShopWallet(stateId: currentStateId, cityId: currentCityId, postCode: post!
                                   , content: addressInput.text,phoneNumber:phone!)
                               walletPayment.shopVC = self
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
            StateList.shopViewController = self
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
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let cityLabel:UILabel = {
        var label = UILabel()
        label.text = "شهر :"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addressLabel:UILabel = {
        var label = UILabel()
        label.text = "آدرس :"
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let postCodeInput:UITextField = {
       var post = UITextField()
        post.backgroundColor = UIColor.darkGray
        post.layer.borderColor = UIColor.black.cgColor
        post.layer.borderWidth = 1.0
        post.textColor = UIColor.white
        post.placeholder = " اختیاری "
        post.borderStyle = .roundedRect
        post.textAlignment = .center
        post.layer.cornerRadius = 5
        post.font = UIFont(name: "IRANSans", size: 13)
        post.attributedPlaceholder =
            NSAttributedString(string: "اختیاری", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.5)])
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
        label.textColor = .white
        label.font = UIFont(name: "IRANSans", size:13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let postalCodeLabel:UILabel = {
        var label = UILabel()
        label.text = "کد پستی :"
        label.textColor = .white
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
        post.placeholder = "اجباری"
        post.layer.cornerRadius = 5
        post.textAlignment = .center
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.attributedPlaceholder =
            NSAttributedString(string: "اجباری", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.5)])
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
        post.placeholder = "کد ده رقمی"
        post.layer.cornerRadius = 5
        post.textAlignment = .center
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.attributedPlaceholder =
            NSAttributedString(string: "کد ده رقمی", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.5)])
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
           label.text = " ۷ "
           label.textColor = .white
           label.font = UIFont(name: "IRANSans", size:15)
           label.textAlignment = .left
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gamePricee = game.price
        title = "خرید بازی"
        postalCodeInput.delegate = self
        mobileNumberInput.delegate = self
        view.backgroundColor = UIColor.backgroundThem
        scrollView.bounces = true
        font = UIFont(name: "IRANSans", size: 13)
        SVProgressHUD.setFont(self.font)
        addressInput.delegate = self
        StateList = BottomListShop()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        hideKeyboardWhenTappedAround()
        // ADD VIEW'S
        containerView.backgroundColor = UIColor.backgroundThem
//        containerView.addSubview(productLabel)
        containerView.addSubview(firstView)
//        fvSetup()
        containerView.addSubview(address)
        containerView.addSubview(secondView)
        secondSetup()
        
//        containerView.addSubview(thirdViewLabel)
//               containerView.addSubview(thirdView)
//        thirdViewSetup()
        
        containerView.addSubview(payment)
        containerView.addSubview(fourthView)
        fourthViewSetup()
        
        
        //first view items

//        firstView.addSubview(nameLabel)
//        nameLabelSetup()
//        firstView.addSubview(region)
//        regionSetup()
//        firstView.addSubview(genre)
//        genreSetup()
//
//        firstView.addSubview(gameName)
//        gameNameSetup()
//        firstView.addSubview(gameRegion)
//        gameRegionSetup()
//        firstView.addSubview(gamegenre)
//        gameGenreSetup()

//second view items
        

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
      
        
        
        //fourthView view configuration
//        thirdView.addSubview(payment)
//        paymentLabelSetup()
        fourthView.addSubview(gamePriceLabel)
        setupPriceLabel()
        fourthView.addSubview(gamePrice)
        setupPrice()
        
//        fourthView.addSubview(gameRentLabel)
//        setupRentPriceLabel()
//        fourthView.addSubview(gameRentPrice)
//        setupRentPrice()
        fourthView.addSubview(gamePostPriceLabel)
        setupPostPriceLabel()
        fourthView.addSubview(gamePostPrice)
        setupPostPrice()
        fourthView.addSubview(totalPriceLabel)
        setupTotalPriceLabel()
        fourthView.addSubview(totalPrice)
        setupTotalPrice()
        fourthView.addSubview(discountInput)
        fourthView.addSubview(discountButton)
        setupDiscount()
        fourthView.addSubview(btnStack)
        setupStackView()
        
    }
    
    
    @objc func handleDiscount(){
            if discountInput.text!.count > 3  {
                 SVProgressHUD.show(withStatus: "در حال انجام...")
                Discount.getInfo(for: discountInput.text!,token: getToken()) { (status, message, discountPercent) in
                    if status == 1{
                        guard let discountPercent = discountPercent else{ return}
                         
                        SVProgressHUD.showSuccess(withStatus: "کد تخفیف اعمال شد.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        let GameDiscountPrice = Int(self.game.price)/100*discountPercent
                        //new price after discount
                        self.gamePrice.text = " (تخفیف اعمال شد.) " +  self.convertToPersian(inputStr: "\(String(describing: ( Int(self.game.price) - GameDiscountPrice ).formattedWithSeparator))") + " تومان "
                        self.gamePrice.font = UIFont(name: "IRANSans", size: 12)
                        self.totalPrice.text = self.convertToPersian(inputStr: "\(String(describing: ( Int(self.game.price) - GameDiscountPrice ).formattedWithSeparator))") + " تومان"
                        self.discountButton.setTitle("اعمال شد.", for: .normal)
                        self.discountButton.isEnabled = false
                        self.discountInput.isEnabled = false

                    }else{
                        
                        SVProgressHUD.showError(withStatus: message)
                        SVProgressHUD.dismiss(withDelay: 3)
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

    
    
    //third view setup.
    
        fileprivate func thirdViewSetup(){
            thirdViewLabel.topAnchor.constraint(equalTo: secondView.bottomAnchor, constant: 32).isActive = true
            thirdViewLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
            let top = thirdView.topAnchor.constraint(equalTo: thirdViewLabel.bottomAnchor, constant: 8)
            let right = thirdView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
            let left = thirdView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
            let height = thirdView.heightAnchor.constraint(equalToConstant: 60)
            NSLayoutConstraint.activate([top,right,left,height])
        }
        
    
        fileprivate func setupDeliverPeriod(){
            deliverPeriodLabel.topAnchor.constraint(equalTo: thirdView.topAnchor, constant:20 ).isActive = true
            deliverPeriodLabel.trailingAnchor.constraint(equalTo: thirdView.trailingAnchor, constant: -16).isActive = true
            deliverPeriodLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
            
            deliverPeriod.topAnchor.constraint(equalTo: thirdView.topAnchor, constant: 16).isActive = true
            deliverPeriod.leftAnchor.constraint(equalTo: thirdView.leftAnchor, constant: 8).isActive = true
            deliverPeriod.rightAnchor.constraint(equalTo: deliverPeriodLabel.leftAnchor, constant: 0).isActive = true
        }

    //fourth view constraints
    
    fileprivate func setupDiscount(){
//        discountStack.addArrangedSubview(discountButton)
//        discountStack.addArrangedSubview(discountInput)
        discountInput.topAnchor.constraint(equalTo: dividerView7.bottomAnchor, constant: 8).isActive = true
        discountInput.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        discountInput.widthAnchor.constraint(equalTo: fourthView.widthAnchor, multiplier: 0.7).isActive = true
        discountButton.topAnchor.constraint(equalTo: dividerView7.bottomAnchor, constant: 8).isActive = true
        discountButton.rightAnchor.constraint(equalTo: discountInput.leftAnchor, constant: -8).isActive = true
        discountButton.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
//
//        fourthView.addSubview(dividerView8)
//        dividerView8.topAnchor.constraint(equalTo: discountButton.bottomAnchor, constant: 8).isActive = true
//        dividerView8.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
//        dividerView8.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        dividerView8.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
    }
    
    fileprivate func setupStackView(){
        btnStack.addArrangedSubview(localPayButton)
        btnStack.addArrangedSubview(ePayButton)
//        btnStack.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 8).isActive = true
        btnStack.bottomAnchor.constraint(equalTo: fourthView.bottomAnchor, constant: -8).isActive = true
        btnStack.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        btnStack.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
    }
    
    fileprivate func setupTotalPrice(){
        totalPrice.topAnchor.constraint(equalTo: dividerView6.bottomAnchor, constant: 8).isActive = true
        totalPrice.rightAnchor.constraint(equalTo: totalPriceLabel.leftAnchor, constant: 8).isActive = true
        totalPrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        totalPrice.text = convertToPersian(inputStr: String(describing:"\(Int(game.price).formattedWithSeparator)")) + " تومان"
    
        fourthView.addSubview(dividerView7)
        dividerView7.topAnchor.constraint(equalTo: totalPrice.bottomAnchor, constant: 8).isActive = true
        dividerView7.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        dividerView7.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView7.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func setupTotalPriceLabel(){
        totalPriceLabel.topAnchor.constraint(equalTo: dividerView6.bottomAnchor, constant: 8).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
    }
    
    
    fileprivate func setupPostPrice(){
        gamePostPrice.topAnchor.constraint(equalTo: dividerView5.bottomAnchor, constant: 8).isActive = true
        gamePostPrice.rightAnchor.constraint(equalTo: gamePostPriceLabel.leftAnchor, constant: 8).isActive = true
        gamePostPrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        gamePostPrice.text = "۰" + " تومان "
        
        fourthView.addSubview(dividerView6)
        dividerView6.topAnchor.constraint(equalTo: gamePostPrice.bottomAnchor, constant: 8).isActive = true
        dividerView6.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        dividerView6.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView6.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        
    }
   fileprivate func setupPostPriceLabel(){
        gamePostPriceLabel.topAnchor.constraint(equalTo: dividerView5.bottomAnchor, constant: 8).isActive = true
        gamePostPriceLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
    }
    
    fileprivate func setupRentPrice(){
        gameRentPrice.topAnchor.constraint(equalTo: gamePrice.bottomAnchor, constant: 8).isActive = true
//        gameRentPrice.rightAnchor.constraint(equalTo: gameRentLabel.leftAnchor, constant: 8).isActive = true
        gameRentPrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        
    }
    fileprivate func setupRentPriceLabel(){
        gameRentLabel.topAnchor.constraint(equalTo: gamePriceLabel.bottomAnchor, constant: 8).isActive = true
        gameRentLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
    }
    
    
    fileprivate func setupPrice(){
        gamePrice.topAnchor.constraint(equalTo: fourthView.topAnchor, constant: 8).isActive = true
        gamePrice.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        gamePrice.text = convertToPersian(inputStr: "\(Int(game.price).formattedWithSeparator)") + " تومان "
        
        fourthView.addSubview(dividerView5)
        dividerView5.topAnchor.constraint(equalTo: gamePrice.bottomAnchor, constant: 8).isActive = true
        dividerView5.leftAnchor.constraint(equalTo: fourthView.leftAnchor, constant: 8).isActive = true
        dividerView5.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView5.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
        
    }
    fileprivate func setupPriceLabel(){
        gamePriceLabel.topAnchor.constraint(equalTo: fourthView.topAnchor, constant: 8).isActive = true
        gamePriceLabel.rightAnchor.constraint(equalTo: fourthView.rightAnchor, constant: -8).isActive = true
    }

    
       func convertToPersian(inputStr:String)-> String {
           let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
           var str : String = inputStr
           
           for (key,value) in numbersDictionary {
               str =  str.replacingOccurrences(of: key, with: value)
           }
           
           return str
       }
    
    
    
    
    
    //second view
    fileprivate func setupPostalCodeInput(){
        postalCodeInput.topAnchor.constraint(equalTo: dividerView4.bottomAnchor, constant: 8).isActive = true
        postalCodeInput.rightAnchor.constraint(equalTo: postalCodeLabel.leftAnchor, constant: 0).isActive = true
        postalCodeInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        
//        secondView.addSubview(dividerView5)
//        dividerView5.topAnchor.constraint(equalTo: postalCodeInput.bottomAnchor, constant: 8).isActive = true
//        dividerView5.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        dividerView5.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
//        dividerView5.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func setuPostalCodelabel(){
        postalCodeLabel.topAnchor.constraint(equalTo: dividerView4.bottomAnchor, constant:8 ).isActive = true
        postalCodeLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16).isActive = true
        postalCodeLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
    }
    fileprivate func setupMobileInput(){
        mobileNumberInput.topAnchor.constraint(equalTo: dividerView3.bottomAnchor, constant: 8).isActive = true
        mobileNumberInput.rightAnchor.constraint(equalTo: mobileLabel.leftAnchor, constant: 0).isActive = true
        mobileNumberInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        
        secondView.addSubview(dividerView4)
        dividerView4.topAnchor.constraint(equalTo: mobileNumberInput.bottomAnchor, constant: 8).isActive = true
        dividerView4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView4.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        dividerView4.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func setupMobileLabel(){
        mobileLabel.topAnchor.constraint(equalTo: dividerView3.bottomAnchor, constant: 8).isActive = true
        mobileLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16).isActive = true
        mobileLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
    }
    fileprivate func setupAddressInput(){
//        addressInput.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillShown)))
        addressInput.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant:8 ).isActive = true
        addressInput.rightAnchor.constraint(equalTo: addressLabel.leftAnchor, constant: 0).isActive = true
        addressInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        addressInput.heightAnchor.constraint(equalToConstant: view.frame.size.height / 11).isActive = true
        
        secondView.addSubview(dividerView3)
        dividerView3.topAnchor.constraint(equalTo: addressInput.bottomAnchor, constant: 8).isActive = true
        dividerView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView3.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        dividerView3.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func setupAddress(){
        addressLabel.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16).isActive = true
        addressLabel.widthAnchor.constraint(equalToConstant: view.frame.width/5).isActive = true
    }
    fileprivate func setupCitySelectBtn(){
        selectCityBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        selectCityBtn.topAnchor.constraint(equalTo: dividerView1.bottomAnchor, constant: 8).isActive = true
        selectCityBtn.widthAnchor.constraint(equalToConstant: view.frame.width/8).isActive = true
        
        secondView.addSubview(dividerView2)
        dividerView2.topAnchor.constraint(equalTo: selectCityBtn.bottomAnchor, constant: 8).isActive = true
        dividerView2.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        dividerView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView2.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    
    fileprivate func citySetup(){
        city.rightAnchor.constraint(equalTo: cityLabel.leftAnchor, constant: -8).isActive = true
        city.leftAnchor.constraint(equalTo: selectCityBtn.rightAnchor, constant: 8).isActive = true
        city.topAnchor.constraint(equalTo: dividerView1.bottomAnchor, constant: 8).isActive = true
    }
    
    fileprivate func setupCityLabel(){
        cityLabel.topAnchor.constraint(equalTo: dividerView1.bottomAnchor, constant: 8).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -16).isActive = true
    }
    
    fileprivate func setupStateSelectBtn(){
        selectStateBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        selectStateBtn.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 8).isActive = true
        selectStateBtn.widthAnchor.constraint(equalToConstant: view.frame.width/8).isActive = true
        
        secondView.addSubview(dividerView1)
        dividerView1.topAnchor.constraint(equalTo: selectStateBtn.bottomAnchor, constant: 8).isActive = true
        dividerView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView1.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        dividerView1.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func mobileNubmerInputSetup(){
        mobileNumberInput.rightAnchor.constraint(equalTo: mobileLabel.leftAnchor, constant: -8).isActive = true
        mobileNumberInput.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        mobileNumberInput.topAnchor.constraint(equalTo: postCodeInput.bottomAnchor, constant: 14).isActive = true
        
    }
    fileprivate func mobileLabelSetup(){
        mobileLabel.topAnchor.constraint(equalTo: postCodeInput.bottomAnchor, constant: 16 ).isActive = true
        mobileLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -16).isActive = true
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
        stateLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -16).isActive = true
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
    }
    fileprivate func gameRegionSetup(){
        gameRegion.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 16).isActive = true
        gameRegion.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func gameGenreSetup(){
        gamegenre.topAnchor.constraint(equalTo: gameRegion.bottomAnchor, constant: 16).isActive = true
        gamegenre.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func gameRentPriodSetup(){
          gameRentPriod.topAnchor.constraint(equalTo: gamegenre.bottomAnchor, constant: 16).isActive = true
          gameRentPriod.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
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


    // setup main views
    fileprivate func fourthViewSetup(){
        payment.topAnchor.constraint(equalTo: secondView.bottomAnchor, constant: 16).isActive = true
        payment.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = fourthView.topAnchor.constraint(equalTo: payment.bottomAnchor, constant: 8)
        let bottom = fourthView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        let right = fourthView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = fourthView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        let height = fourthView.heightAnchor.constraint(equalToConstant: 240)
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
        let heightSize = (contentEstimatedFrame.height * 5) + 4 * 16 + 6 * 5 + addresHeight/2 + 2 * 20
        let height = secondView.heightAnchor.constraint(equalToConstant: heightSize)
        
//        let height = secondView.heightAnchor.constraint(equalToConstant: 250)
        NSLayoutConstraint.activate([top,right,left,height])
    }
    fileprivate func fvSetup(){
        productLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        productLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = firstView.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 8)
        let right = firstView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = firstView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        NSLayoutConstraint.activate([top,right,left])
        let contentSize = CGSize(width: containerView.frame.width, height: 1000)
        contentFont = UIFont(name: "IRANSans", size: 13)
        let contentEstimatedFrame = NSString(string: gameRentPriod.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
        firstView.heightAnchor.constraint(equalToConstant: 170 - contentEstimatedFrame.height - 16).isActive = true
        
        
 }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
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
    
    //check phone and post code character count
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
    
    

}
